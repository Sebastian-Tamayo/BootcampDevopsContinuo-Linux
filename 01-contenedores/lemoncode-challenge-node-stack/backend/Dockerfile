# Imagen base ligera con Node LTS
FROM node:20-slim

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar manifiestos primero (mejor caché de capas en builds siguientes)
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --omit=dev

# Copiar el resto del código de la aplicación
COPY . .

# Puerto que expone la API
EXPOSE 5000

# Arrancar Express
CMD ["npm", "start"]
