---
name: github-setup
description: Configura GitHub Actions para revisar PRs automáticamente con Claude
version: 1.0.0
agent: shared
---

## Propósito

Crea e instala un GitHub Actions workflow que revisa automáticamente todas las PRs con Claude Sonnet 4.6.

Cuando alguien abre o actualiza una PR, el bot de Claude:
1. Descarga el diff
2. Analiza los cambios
3. Comenta con recomendaciones

## Requisitos previos

- Repositorio GitHub inicializado
- Acceso a GitHub secrets del repo
- Clave API de Anthropic (`ANTHROPIC_API_KEY`)

## Instalación

### Paso 1: Generar el workflow

```bash
# Copia el workflow template a tu repo
mkdir -p .github/workflows
cat > .github/workflows/claude-pr-review.yml << 'EOF'
name: Claude PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  claude-review:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
      contents: read
    
    steps:
      - name: Checkout PR branch
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get PR diff
        id: diff
        run: |
          git fetch origin pull/${{ github.event.pull_request.number }}/head:pr-branch
          git diff origin/${{ github.event.pull_request.base.ref }}...pr-branch > pr.diff
          DIFF_SIZE=$(wc -c < pr.diff)
          if [ $DIFF_SIZE -gt 100000 ]; then
            echo "LARGE_DIFF=true" >> $GITHUB_OUTPUT
            head -c 100000 pr.diff > pr.diff.truncated
            mv pr.diff.truncated pr.diff
          else
            echo "LARGE_DIFF=false" >> $GITHUB_OUTPUT
          fi
          cat pr.diff

      - name: Call Claude API
        id: claude
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          PR_TITLE: ${{ github.event.pull_request.title }}
          PR_DESCRIPTION: ${{ github.event.pull_request.body }}
        run: |
          node - << 'SCRIPT'
          const https = require('https');
          const fs = require('fs');
          
          const diff = fs.readFileSync('pr.diff', 'utf-8');
          const title = process.env.PR_TITLE || '';
          const description = process.env.PR_DESCRIPTION || '';
          const largeNote = process.env.LARGE_DIFF === 'true' ? '\n⚠️ Diff truncado (>100KB) — solo primeros 100KB analizados.' : '';
          
          const prompt = `Review this GitHub PR and provide concise, actionable feedback.

PR Title: ${title}
PR Description: ${description}

Code changes:
\`\`\`diff
${diff}
\`\`\`

Provide:
1. Summary of changes (1-2 sentences)
2. Potential issues or improvements (bullet points)
3. Questions or concerns (if any)

Be brief and constructive.${largeNote}`;

          const payload = JSON.stringify({
            model: 'claude-sonnet-4-6',
            max_tokens: 1024,
            messages: [
              {
                role: 'user',
                content: prompt
              }
            ]
          });

          const options = {
            hostname: 'api.anthropic.com',
            port: 443,
            path: '/v1/messages',
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Content-Length': Buffer.byteLength(payload),
              'x-api-key': process.env.ANTHROPIC_API_KEY,
              'anthropic-version': '2023-06-01'
            }
          };

          const req = https.request(options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
              try {
                const response = JSON.parse(data);
                if (response.error) {
                  console.error('API Error:', response.error.message);
                  process.exit(1);
                }
                const review = response.content[0].text;
                console.log(review);
                fs.writeFileSync('review.txt', review);
              } catch (e) {
                console.error('Parse error:', e.message);
                process.exit(1);
              }
            });
          });

          req.on('error', (e) => {
            console.error('Request error:', e.message);
            process.exit(1);
          });

          req.write(payload);
          req.end();
          SCRIPT

      - name: Post review comment
        if: always()
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            let comment = '## 🔍 Claude Code Review\n\n';
            
            if (fs.existsSync('review.txt')) {
              const review = fs.readFileSync('review.txt', 'utf-8');
              comment += review;
            } else {
              comment += 'Review failed or pending. Check action logs.';
            }
            
            comment += '\n\n---\n*Reviewed by [Claude Code](https://claude.ai/code) via GitHub Actions*';
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: comment
            });
EOF
```

### Paso 2: Configurar API key en GitHub

1. Ve a `Settings → Secrets and variables → Actions`
2. Haz clic en "New repository secret"
3. Nombre: `ANTHROPIC_API_KEY`
4. Valor: Tu clave API de Anthropic (desde https://console.anthropic.com)
5. Haz clic en "Add secret"

### Paso 3: Commitear el workflow

```bash
git add .github/workflows/claude-pr-review.yml
git commit -m "ci: add Claude PR review workflow"
git push
```

## Uso

Simplemente **abre una PR** en el repo. El workflow se dispara automáticamente y Claude comenta con la revisión.

## Desactivación

Para desactivar sin borrar:
```bash
# Renombra el archivo
mv .github/workflows/claude-pr-review.yml .github/workflows/claude-pr-review.yml.disabled
```

Para reactivar:
```bash
mv .github/workflows/claude-pr-review.yml.disabled .github/workflows/claude-pr-review.yml
```

## Troubleshooting

| Problema | Solución |
|----------|----------|
| "API key invalid" | Verifica que `ANTHROPIC_API_KEY` está en repo secrets |
| "No comment posted" | Revisa logs del action: PR → "Checks" → "Claude PR Review" |
| "Diff too large" | El workflow trunca diffs >100KB automáticamente |
| "Rate limit" | Anthropic API límites varían por plan; verifica console.anthropic.com |

## Notas de seguridad

- Nunca commitees `ANTHROPIC_API_KEY` en el código
- Usa GitHub secrets, siempre
- El workflow solo tiene permiso `read` en el código, `write` solo en comentarios
- Los diffs se procesan localmente en GitHub Actions, no se envían a terceros excepto Anthropic API
