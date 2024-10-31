FROM python:3.13-slim-bullseye

LABEL maintainer="Franklin D <devsecfranklin@duck.com>"
LABEL org.opencontainers.image.source="https://github.com/devsecfranklin/paper-cloud-lab"
LABEL org.opencontainers.image.description="Cloudlab Paper"
LABEL org.opencontainers.image.licenses=MIT
RUN apt update

RUN ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime
RUN apt install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt install -y texlive-full python3-pygments latexmk

WORKDIR /project

COPY .latexmkrc /root

CMD latexmk -pvc -pdf -view=none -silent -time cloudlab.tex
