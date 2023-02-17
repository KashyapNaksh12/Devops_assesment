FROM maven:3.5-jdk-8 as maven

# copy the project files
COPY ./pom.xml ./pom.xml

# build all dependencies
RUN mvn dependency:go-offline -B

# copy your other files
COPY ./src ./src

#RUN mvn package
RUN mvn clean install -DskipTests

#Listing the jar file 
RUN ls -la target/*.jar

FROM openjdk:8
# Don't change the base image

# set deployment directory
WORKDIR /Devops

# copy over the built artifact from the maven image
COPY --from=maven target/*.jar ./

# set the startup command to run your binary
CMD java -jar -Xmx800m /Devops/postgres-demo-0.0.1-SNAPSHOT.jar
