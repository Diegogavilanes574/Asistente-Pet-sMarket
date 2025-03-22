# Utiliza la imagen oficial de Flutter con una versión compatible
FROM google/flutter:latest

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de configuración de Flutter
COPY pubspec.* ./

# Instala las dependencias del proyecto
RUN flutter pub get

# Copia el resto del proyecto
COPY . .

# Compila la aplicación
RUN flutter build apk --release

# Comando para iniciar el servidor
CMD ["flutter", "run"]
