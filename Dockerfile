# Utiliza una imagen de Python ligera
FROM python:3.9-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar las dependencias necesarias para mysqlclient y compilación
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev libffi-dev \
    libmysqlclient-dev python3-dev gcc && \
    apt-get clean

# Copiar el archivo de requerimientos primero para aprovechar el caché
COPY requirements.txt .

# Instalar dependencias del proyecto
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de los archivos del proyecto
COPY . .

# Exponer el puerto de la aplicación
EXPOSE 5000

# Ejecutar el servidor Flask
CMD ["python", "server.py"]
