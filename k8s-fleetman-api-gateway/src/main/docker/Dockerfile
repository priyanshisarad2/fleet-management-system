FROM maven:3.6.3-jdk-8-slim AS build

WORKDIR /app

COPY pom.xml ./
COPY src ./src

RUN mvn -q -DskipTests -Ddocker.skip=true package


FROM eclipse-temurin:8-jre-alpine

LABEL org.opencontainers.image.authors="Priyanshi Sarad <itspriyanshisarad@gmail.com>"

EXPOSE 8080

WORKDIR /usr/local/bin/

COPY --from=build /app/target/*.jar webapp.jar

CMD ["java", "-jar", "webapp.jar"]