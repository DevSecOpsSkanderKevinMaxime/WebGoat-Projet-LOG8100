# Stage 1: Build
FROM docker.io/eclipse-temurin:21-jdk-jammy as builder

# Copy the Maven wrapper and pom.xml first to leverage Docker caching
COPY .mvn/ .mvn/
COPY mvnw mvnw
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B

# Copy the source code and compile it
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM docker.io/eclipse-temurin:21-jdk-jammy

RUN \
  useradd -ms /bin/bash webgoat && \
  chgrp -R 0 /home/webgoat && \
  chmod -R g=u /home/webgoat

USER webgoat

# Copy the built .jar file from the builder stage
COPY --from=builder target/webgoat-*.jar /home/webgoat/webgoat.jar

EXPOSE 8080 9090

WORKDIR /home/webgoat

ENTRYPOINT [ "java", \
   "-Duser.home=/home/webgoat", \
   "-Dfile.encoding=UTF-8", \
   "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
   "--add-opens", "java.base/java.util=ALL-UNNAMED", \
   "--add-opens", "java.base/java.lang.reflect=ALL-UNNAMED", \
   "--add-opens", "java.base/java.text=ALL-UNNAMED", \
   "--add-opens", "java.desktop/java.beans=ALL-UNNAMED", \
   "--add-opens", "java.desktop/java.awt.font=ALL-UNNAMED", \
   "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
   "--add-opens", "java.base/java.io=ALL-UNNAMED", \
   "--add-opens", "java.base/java.util=ALL-UNNAMED", \
   "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
   "--add-opens", "java.base/java.io=ALL-UNNAMED", \
   "-Drunning.in.docker=true", \
   "-jar", "webgoat.jar", "--server.address", "0.0.0.0" ]

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl --fail http://localhost:8080/WebGoat/actuator/health || exit 1
