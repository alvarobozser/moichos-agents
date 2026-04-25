---
name: implement
description: Generar código nuevo que cumpla los requisitos respetando convenciones del proyecto
version: 1.0.0
agent: coder
---

## Cuándo usar

Cuando el Planner o el Orquestador entrega una tarea de codificación con requisitos definidos.

## Nivel 1 — Inicio rápido

1. Lee el fichero de convenciones: `shared/resources/conventions.md`
2. Identifica el fichero(s) destino; si no existe, crea uno siguiendo la estructura existente
3. Implementa el mínimo necesario para cumplir el requisito
4. Nombra todo con intención: sin abreviaturas, sin magic numbers

## Nivel 2 — Si el cambio afecta a varios módulos

- Dibuja mentalmente el flujo de datos antes de escribir
- Empieza por las capas más internas (dominio / lógica) y avanza hacia afuera
- Una función = una responsabilidad; máx. ~20 líneas como guía
- Si necesitas más de 4 parámetros, usa un objeto/DTO

## Nivel 3 — Si hay ambigüedad en el requisito

- No inventes comportamiento
- Implementa el caso más simple y señala `// TODO: aclarar comportamiento para X`
- Notifica al Orquestador antes de continuar con casos borde

## Checklist pre-entrega

- [ ] Sin credenciales ni secrets hardcodeados
- [ ] Entrada del usuario validada
- [ ] Excepciones capturadas con contexto (no `catch {}` vacío)
- [ ] Nombres descriptivos en funciones y variables
- [ ] Sin código comentado ni console.log de debug

## Recursos

- [../resources/patterns.md](../resources/patterns.md)
- [../../../shared/resources/conventions.md](../../../shared/resources/conventions.md)
