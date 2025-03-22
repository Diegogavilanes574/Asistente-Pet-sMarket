# Utiliza una imagen de Python ligera
FROM python:3.9-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Actualizar y agregar repositorios
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get install -y build-essential libssl-dev libffi-dev \
    libmysqlclient-dev python3-dev gcc && \
    apt-get clean

# Copiar los archivos del proyecto al contenedor
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto de la aplicación
EXPOSE 5000

# Ejecutar el servidor Flask
CMD ["python", "server.py"]
