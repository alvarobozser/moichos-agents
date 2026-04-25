---
name: filesystem
description: Operaciones de ficheros y directorios seguras y compatibles con todos los agentes
version: 1.0.0
agent: shared
---

## Cuándo usar

Cualquier agente que necesite leer, crear o modificar ficheros.

## Nivel 1 — Lecturas (siempre seguras)

```bash
ls -la <directorio>       # listar contenido con detalles
cat <fichero>             # leer fichero completo
head -n 50 <fichero>      # primeras 50 líneas
tail -n 50 <fichero>      # últimas 50 líneas
find . -name "*.ts"       # buscar ficheros por patrón
grep -rn "<patrón>"       # buscar contenido en ficheros
```

## Nivel 2 — Escritura (notificar al Orquestador)

- Al crear un fichero nuevo: indica la ruta y el propósito
- Al modificar un fichero existente: indica qué cambia y por qué
- Preferir edición de ficheros existentes a crear ficheros nuevos
- No tocar más ficheros de los estrictamente necesarios

## Nivel 3 — Operaciones destructivas (confirmación del usuario)

```bash
rm -rf       # ⚠️ eliminar directorio y contenido
mv           # ⚠️ mover / renombrar (puede sobreescribir)
truncate     # ⚠️ vaciar fichero
```

Nunca ejecutes estas operaciones sin confirmación explícita del usuario.

## Patrones a evitar en el código

| Patrón peligroso | Alternativa |
|-----------------|-------------|
| Rutas absolutas hardcodeadas | Variables de entorno o configuración |
| Permisos `chmod 777` | Mínimo privilegio necesario |
| Escritura sin verificar si existe | Comprobar antes de sobreescribir |

## Compatibilidad Windows / Unix

Para scripts cross-platform:
- Usa `/` como separador en rutas (funciona en ambos)
- Para scripts de shell: crea `.sh` y `.ps1`
- Evita comandos solo disponibles en un OS; si es necesario, crea ambas versiones
