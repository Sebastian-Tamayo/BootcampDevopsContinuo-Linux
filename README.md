# Ejercicios Bootcamp DevOps

Repositorio de entregas del [Bootcamp DevOps de Lemoncode](https://lemoncode.net/bootcamp-devops#bootcamp-devops/inicio).

Estructura por módulos (igual que el material del bootcamp) para ir subiendo cada entrega de forma ordenada.

## Estructura

```text
00-fundamentos-linux/     → Ejercicios Bash / CLI
01-contenedores/          → Docker + Lemoncode Challenge
02-orquestacion/          → Kubernetes (pendiente)
03-cd/                    → CI/CD (pendiente)
04-cloud/                 → Cloud (pendiente)
05-iac/                   → Terraform (pendiente)
06-monitoring/            → Observabilidad (pendiente)
07-ia/                    → IA (pendiente)
```

## Estado de entregas

| Módulo | Contenido | Estado |
|--------|-----------|--------|
| 00 Fundamentos Linux | Ejercicios 3, 4 y 5 | ✅ Subido |
| 01 Contenedores | Lemoncode Challenge (node-stack) | ✅ Subido |
| 02 Orquestación | — | ⏳ Pendiente |
| 03 CI/CD | — | ⏳ Pendiente |
| 04 Cloud | — | ⏳ Pendiente |
| 05 IaC | — | ⏳ Pendiente |
| 06 Monitoring | — | ⏳ Pendiente |
| 07 IA | — | ⏳ Pendiente |

## Enlaces rápidos

- [Ejercicio 3 (Linux)](./00-fundamentos-linux/ejercicio-03/ejercicio3.sh)
- [Ejercicio 4 (Linux)](./00-fundamentos-linux/ejercicio-04/ejercicio4.sh)
- [Ejercicio 5 (Linux)](./00-fundamentos-linux/ejercicio-05/ejercicio5.sh)
- [Lemoncode Challenge — node-stack](./01-contenedores/lemoncode-challenge-node-stack/)
- [Documentación del Challenge](./01-contenedores/lemoncode-challenge-node-stack/ENTREGA.md)

## Cómo reproducir el Challenge (Contenedores)

```bash
cd 01-contenedores/lemoncode-challenge-node-stack
docker compose up --build -d
docker compose ps
# Abrir http://localhost:3000
```

## Autor

Sebastián Tamayo — Bootcamp DevOps Lemoncode
