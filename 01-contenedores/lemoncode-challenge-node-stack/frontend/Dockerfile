# Imagen base ligera con Node LTS
FROM node:20-slim

WORKDIR /app

# Manifiestos primero para aprovechar la caché de capas
COPY package*.json ./

# Producción: sin jest ni otras devDependencies
RUN npm ci --omit=dev

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
