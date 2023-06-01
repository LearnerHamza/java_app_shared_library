FROM openjdk:10-ea-32-jre-slim
WORKDIR /app
COPY ./target/*.jar /app.jar
CMD [ "java", "-jar", "app.jar"]