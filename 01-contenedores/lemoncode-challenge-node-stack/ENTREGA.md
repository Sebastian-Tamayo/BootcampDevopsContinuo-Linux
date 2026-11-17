# Entrega â€” Lemoncode Challenge (node-stack)

DocumentaciÃ³n de comandos, archivos y evidencias de los 4 retos.

Stack: **Node.js** (`backend` + `frontend`) + **MongoDB**.

**Estado validado:** `docker compose up --build -d` con 3 servicios `Up`, UI en http://localhost:3000 con *Backend conectado*.

**Paquete ZIP listo para subir:** `../lemoncode-challenge-node-stack-ENTREGA.zip` (incluye `.env`, Dockerfiles, `compose.yml`, `ENTREGA.md` y carpeta `evidencias/`).

---

## Checklist de entregables

| Reto | Entregable | UbicaciÃ³n |
|------|------------|-----------|
| 1 | Comandos red + Mongo | abajo + este doc |
| 1 | Config conexiÃ³n backend | `backend/.env` |
| 1 | Prueba REST Client | [`evidencias/reto1-rest-client.png`](evidencias/reto1-rest-client.png) |
| 2 | Dockerfile backend | [`backend/Dockerfile`](backend/Dockerfile) |
| 2 | Build / run | abajo |
| 2 | Prueba REST Client | [`evidencias/reto2-rest-client.png`](evidencias/reto2-rest-client.png) |
| 3 | Dockerfile frontend | [`frontend/Dockerfile`](frontend/Dockerfile) |
| 3 | Build / run + env | abajo + `frontend/.env` |
| 3 | UI | [`evidencias/reto3-frontend-3000.png`](evidencias/reto3-frontend-3000.png) |
| 4 | `compose.yml` comentado | [`compose.yml`](compose.yml) |
| 4 | Variables | [`.env`](.env) |
| 4 | `docker compose ps` | [`evidencias/reto4-compose-ps.png`](evidencias/reto4-compose-ps.png) |
| 4 | App completa | [`evidencias/reto4-app-localhost-3000.png`](evidencias/reto4-app-localhost-3000.png) |

---

## Reto 1: MongoDB en contenedor

### 1. Crear la red Docker

```bash
docker network create lemoncode-network
```

**Por quÃ©:** los contenedores en la misma red bridge se resuelven por nombre DNS (`mongo`, `topics-api`). Sin red comÃºn, no hay comunicaciÃ³n por hostname.

### 2. Volumen + contenedor MongoDB

```bash
docker volume create mongo-data

docker run -d \
  --name mongo \
  --network lemoncode-network \
  -p 27017:27017 \
  -v mongo-data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  mongo:7
```

**Por quÃ© el volumen:** sin `-v`, al borrar el contenedor se pierden los datos. El volumen nombrado `mongo-data` monta `/data/db` y sobrevive a `docker rm`.

**Por quÃ© `-p 27017:27017`:** el backend en el host (Reto 1) habla a `localhost:27017`. Dentro de la red Docker usaremos el hostname `mongo` (Retos 2â€“4).

### 3. ConfiguraciÃ³n del backend local

Archivo `backend/.env`:

```ini
DATABASE_URL=mongodb://admin:password@localhost:27017/?authSource=admin
DATABASE_NAME=LemoncodeCourseDb
HOST=0.0.0.0
PORT=5000
```

`authSource=admin` es necesario porque el usuario root de la imagen oficial se crea en la DB `admin`.

Arranque local:

```bash
cd backend
npm install
npm start
```

### 4. Prueba REST Client / CRUD

Archivo: [`backend/client.http`](backend/client.http) (puerto **5000**).

Validado:

- `GET http://localhost:5000/api/classes` â†’ **200** (listado de clases)
- `POST http://localhost:5000/api/classes` â†’ **201** Created
- `GET` por `_id` â†’ **200**

Evidencia: [`evidencias/reto1-rest-client.png`](evidencias/reto1-rest-client.png)

---

## Reto 2: Dockerizar el backend

### 1. Dockerfile

Archivo: [`backend/Dockerfile`](backend/Dockerfile)

- Copia `package*.json` antes del cÃ³digo â†’ mejor cachÃ© de capas
- `npm ci --omit=dev` â†’ imagen mÃ¡s pequeÃ±a y reproducible
- `EXPOSE 5000` + `CMD ["npm", "start"]`

TambiÃ©n: `backend/.dockerignore` (excluye `node_modules`, `.env`, etc.).

### 2. Build

```bash
cd backend
docker build -t topics-api .
```

### 3. Run (misma red que Mongo)

```bash
docker run -d \
  --name topics-api \
  --network lemoncode-network \
  -p 5000:5000 \
  -e DATABASE_URL="mongodb://admin:password@mongo:27017/?authSource=admin" \
  -e DATABASE_NAME=LemoncodeCourseDb \
  -e HOST=0.0.0.0 \
  -e PORT=5000 \
  topics-api
```

**Por quÃ© `mongo` y no `localhost`:** desde dentro del contenedor, `localhost` es el propio contenedor. El DNS de Docker resuelve `mongo` al contenedor MongoDB en `lemoncode-network`.

### 4. ValidaciÃ³n

`GET` â†’ **200**, `POST` â†’ **201** contra `http://localhost:5000/api/classes`. Datos del Reto 1 persisten gracias al volumen.

Evidencia: [`evidencias/reto2-rest-client.png`](evidencias/reto2-rest-client.png)

---

## Reto 3: Dockerizar el frontend

### 1. Dockerfile

Archivo: [`frontend/Dockerfile`](frontend/Dockerfile) + `frontend/.dockerignore`

### 2. Build

```bash
cd frontend
docker build -t lemoncode-frontend .
```

### 3. Run

```bash
docker run -d \
  --name lemoncode-frontend \
  --network lemoncode-network \
  -p 3000:3000 \
  -e API_URL=http://topics-api:5000/api/classes \
  lemoncode-frontend
```

### 4. Variables de entorno

Archivo de referencia: `frontend/.env`

```ini
API_URL=http://topics-api:5000/api/classes
```

**Importante:** el cÃ³digo lee `API_URL` (no `API_URI` del `.env-sample`). El `fetch` ocurre en el **servidor** Node del frontend, por eso puede usar el hostname Docker `topics-api`.

UI: http://localhost:3000 â†’ HTTP **200**, *Backend conectado (N clases cargadas)*.

Evidencia: [`evidencias/reto3-frontend-3000.png`](evidencias/reto3-frontend-3000.png)

---

## Reto 4: Docker Compose

### 1. Archivos

- [`compose.yml`](compose.yml) â€” tres servicios, red, volumen, env, `depends_on`, comentarios
- [`.env`](.env) / [`.env.example`](.env.example) â€” variables (`.env` puede estar en `.gitignore`; el example se versiona; Compose ya lleva env en cada servicio)

### 2. Levantar todo

Antes, limpiar contenedores manuales de los retos 2â€“3 si siguen vivos:

```bash
docker rm -f lemoncode-frontend topics-api mongo
```

```bash
cd 01-contenedores/lemoncode-challenge-node-stack
docker compose up --build -d
```

### 3. Comandos Ãºtiles

```bash
docker compose ps          # estado
docker compose logs -f     # logs
docker compose down        # parar (volumen se conserva)
docker compose down -v     # parar y borrar volÃºmenes (Â¡borra datos!)
```

### 4. Evidencia `docker compose ps`

```
NAME                 IMAGE                SERVICE      STATUS   PORTS
lemoncode-frontend   lemoncode-frontend   frontend     Up       0.0.0.0:3000->3000/tcp
mongo                mongo:7              mongo        Up       0.0.0.0:27017->27017/tcp
topics-api           topics-api           topics-api   Up       0.0.0.0:5000->5000/tcp
```

Captura: [`evidencias/reto4-compose-ps.png`](evidencias/reto4-compose-ps.png)

### 5. AplicaciÃ³n

http://localhost:3000 â€” Calendario Lemoncode con clases de MongoDB (*Backend conectado*).

Captura: [`evidencias/reto4-app-localhost-3000.png`](evidencias/reto4-app-localhost-3000.png)

---

## Mapa de puertos

| Servicio  | Puerto host | Puerto contenedor |
|-----------|-------------|-------------------|
| Frontend  | 3000        | 3000              |
| Backend   | 5000        | 5000              |
| MongoDB   | 27017       | 27017             |

## Arquitectura final

```
Navegador â†’ localhost:3000 â†’ contenedor frontend
                â†“ (API_URL)
         topics-api:5000
                â†“ (DATABASE_URL)
            mongo:27017  (+ volumen mongo-data)
```

## CÃ³mo reproducir la entrega

```bash
cd 01-contenedores/lemoncode-challenge-node-stack
docker compose up --build -d
docker compose ps
# Abrir http://localhost:3000
```

