# Utiliza una imagen base más completa
FROM python:3.9-buster

# Actualizar y agregar repositorios
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -y build-essential libssl-dev libffi-dev libmysqlclient-dev python3-dev gcc && \
    apt-get clean

# Crear el directorio de trabajo
WORKDIR /app

# Copiar el archivo de requerimientos
COPY requirements.txt .

# Instalar las dependencias del proyecto
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de los archivos del proyecto
COPY . .

# Exponer el puerto de la aplicación Flask
EXPOSE 5000

# Comando para ejecutar el servidor Flask
CMD ["python", "server.py"]
