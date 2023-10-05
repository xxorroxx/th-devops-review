# Proceso de creacion de imagen:

En primera instancia, para poder generar una imagen a partir del codigo java proporcionado, se valido que la aplicacion no contenga errores al momento de ejecutarse, la prueba se realizó en ambiente local y como resultado compiló de manera correcta. Se procedió a crear un archivo Dockerfile (conjunto de instrucciones para la creacion de una imagen) para que la aplicacion reuna todas las dependencias necesarias y pueda ejecutarse en cualquier entorno. Dicho archivo require que este en la carpeta raiz del proyecto y previamente a ello se requiere que este "empaquetado" el .jar. El package fue generado mediante mvn y alojado en la carpeta /target (por defecto).
Antes de crear la imagen, explicaré cual es la logica utilizada en el Dockerfile:

###### FROM openjdk:22-slim 
Se invoca la imagen de openjdk 22, por dos razones principales:
	1. El proyecto cuenta con una version de Java 20 lo cual se require una version igual o superior a la misma.
	2. Se utilizó la version slim, reducida en tamaño y cuenta con todos los paquetes necesario e buenas practicas.

###### LABEL maintainer =  "German Sanchez <sanchezgerman@outlook.com>"

###### LABEL company = "Dev&Fun Co."
Metadatos clave-valor, en este caso se ingresan maintainer y company name.

###### COPY target/us-core-vmc-1.0.0.jar /app/app.jar
Se copia el .jar desde el path en donde se realizo el package y se copia al contenedor en el path especificado /app

###### EXPOSE 8080
Se ingresa el valor del puerto que vamos a exponer.

###### ENTRYPOINT ["java","-Dspring.profiles.active=prod", "-jar","/app/app.jar"]
Se ingresan los valores del punto de entrada de la aplicacion que se ejecutara junto al arranque de la misma.
Seleccionar el profile requerido para crear la imagen. Lo ideal es tener mas de una branch para tene los Dockerfiles individuales por cada environment.

Una vez comprendido la estructura del Dockerfile se procede a su ejecucion. Situado en el mismo directorio, en consola se ingresa: 

docker build -t us-core-vmc:1.0.2 .
Se realiza el build a partir del Dockerfile

docker tag us-core-vmc:1.0.2 xxorroxx/us-core-vmc:1.0.2 
Se tagea la imagen creada para poder ser pusheada a dockerhub, la misma tiene que matchear con el repositorio remoto.

docker push xxorroxx/us-core-vmc:1.0.2
Se realiza el push con la imagen previamente tageada, de esta manera queda disponibilizada para ser pulleada.



# Proceso de como aplicar el manifiesto en kubernetes

Para este proceso se dividio el proyecto en dos partes:
	1. nginx-controller
	2. aplicacion spring boot

Se disponibizan de esta manera ya que nginx no es parte de la aplicacion, pero es necesario para poder ingresar a ella desde un navegador. Para ello se crearán dos namespaces.
Los manifiestos tienen la particularidad de disponibilizar todos los objetos del proyecto en un solo archivo, la cual facilita su aplicacion al cluster con un solo comando para "deployar" todo a la vez.

Tener en cuenta en que cluster estoy "parado" en el momento de ejecutar el commando, ya que no seria buena practica tener un proyecto de desarrollo en un cluster productivo. Una vez validado esto, situados en el mismo directorio en donde estan los .yaml se procede mediante interaccion de la consola el comando:

kubectl apply -f path/al/archivo

En esta ocasion se realizo un archivo ejecutable .bat (windows) para que todos los objetos (nginx y aplicacion) se disponibilicen en kubernetes de manera automatica, incluyendo la creacion de los namespaces y objetos en su lugar.

