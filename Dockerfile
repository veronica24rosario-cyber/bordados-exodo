FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
RUN apt-get update && apt-get install -y wget && \
    wget -q https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz && \
    tar -xzf apache-tomcat-10.1.18.tar.gz && \
    mv apache-tomcat-10.1.18 /opt/tomcat && \
    rm apache-tomcat-10.1.18.tar.gz && \
    rm -rf /opt/tomcat/webapps/ROOT && \
    rm -rf /opt/tomcat/webapps/docs && \
    rm -rf /opt/tomcat/webapps/examples && \
    rm -rf /opt/tomcat/webapps/host-manager && \
    rm -rf /opt/tomcat/webapps/manager
COPY --from=build /app/target/bordados-exodo.war /opt/tomcat/webapps/ROOT.war
RUN chmod +x /opt/tomcat/bin/*.sh
ENV PORT=8080
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
