# Imagen para Railway. La oficial se construye con Jib (ghcr.io); esta hace lo
# mismo con un Dockerfile, porque Railway construye desde el repositorio.
# Lo unico que añade es deploy/entrypoint.sh: la clave de firma por variable.

FROM eclipse-temurin:25-jdk AS build
WORKDIR /src
COPY . .
RUN ./gradlew --no-daemon -q -I deploy/copy-runtime.init.gradle.kts \
      wallet-provider-service:copyRuntimeLibs -x test

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /src/wallet-provider-service/build/runtime-libs/ /app/libs/
# El servicio busca "openapi/openapi.json" relativo a su directorio de trabajo.
COPY openapi/openapi.json /app/openapi/openapi.json
COPY deploy/h2-schema.sql /app/h2-schema.sql
COPY deploy/entrypoint.sh /app/entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]
