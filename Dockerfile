FROM openjdk:15-jdk-slim AS build
RUN apt-get update && \
    apt-get install -y \
    make wget
COPY lein /bin/
RUN chmod a+x /bin/lein
RUN mkdir ~/code
WORKDIR ~/code
COPY code/ .
#RUN make test
RUN make libs
RUN make clean all
 
 
FROM adoptopenjdk/openjdk11:jre-11.0.9.1_1-alpine@sha256:b6ab039066382d39cfc843914ef1fc624aa60e2a16ede433509ccadd6d995b1f AS quotes
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY --from=build ~/code/build/quotes.jar /app/quotes.jar
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
EXPOSE 8080
CMD "java" "-jar" "quotes.jar"

FROM adoptopenjdk/openjdk11:jre-11.0.9.1_1-alpine@sha256:b6ab039066382d39cfc843914ef1fc624aa60e2a16ede433509ccadd6d995b1f AS newsfeed
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY --from=build ~/code/build/newsfeed.jar /app/newsfeed.jar
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
EXPOSE 8080
CMD "java" "-jar" "newsfeed.jar"

FROM adoptopenjdk/openjdk11:jre-11.0.9.1_1-alpine@sha256:b6ab039066382d39cfc843914ef1fc624aa60e2a16ede433509ccadd6d995b1f AS front-end
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY --from=build ~/code/build/front-end.jar /app/front-end.jar
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
EXPOSE 8080
CMD "java" "-jar" "front-end.jar"

FROM python:3.9.5-slim AS front-end-static
RUN mkdir /app
RUN addgroup --system pygroup && adduser --disabled-login --gid 101 pyuser
COPY --from=build ~/code/front-end/public /app
WORKDIR /app
RUN chown -R pyuser:pygroup /app
USER pyuser
EXPOSE 8000
CMD "/usr/local/bin/python" "./serve.py"
