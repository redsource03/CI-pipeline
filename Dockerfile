FROM openjdk:8-jre-alpine

ARG version
ARG projectName
ARG profile
ARG port

ENV APPNAME=$projectName
ENV PROFILE=$profile

EXPOSE $port

COPY build/libs/$projectName-$version.jar /opt/services/lib/

WORKDIR /opt/services/lib/

RUN mv $projectName-$version.jar $projectName.jar 
ENTRYPOINT [ "sh", "-c", "java -jar $APPNAME.jar --spring.profiles.active=$PROFILE" ]
