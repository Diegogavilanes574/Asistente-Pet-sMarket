# Utiliza una imagen de Python ligera
FROM python:3.9-slim

# Actualizar los repositorios y agregar herramientas esenciales
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y build-essential libssl-dev libffi-dev python3-dev && \
    apt-get install -y default-libmysqlclient-dev gcc && \
    apt-get clean

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos del proyecto al contenedor
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto de la aplicación
EXPOSE 5000

# Ejecutar el servidor Flask
CMD ["python", "server.py"]
