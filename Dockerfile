FROM alpine:3.8

RUN apk update && apk upgrade
RUN apk add --no-cache curl bash tzdata

# Timezone setzen
ENV TZ Europe/Berlin

RUN mkdir -p /app
WORKDIR /app

# Die Skripte kopieren...
COPY . /app

# Startschirm für Docker-bash
ADD bashrc /root/.bashrc

RUN chmod 777 register.sh
#RUN chmod 777 ministart.sh

# hier spielt die Musik!
CMD ["./register.sh"]
#CMD ["./ministart.sh"]
