FROM openjdk:22-slim

LABEL maintainer =  "German Sanchez <sanchezgerman@outlook.com>"
LABEL company = "Dev&Fun Co."

COPY target/us-core-vmc-1.0.0.jar /app/app.jar

EXPOSE 8080

# Seleccionar el profile requerido para crear la imagen. Lo ideal es tener mas de una branch para tener
# los Dockerfiles individuales por cada environment.
ENTRYPOINT ["java","-Dspring.profiles.active=prod", "-jar","/app/app.jar"]



