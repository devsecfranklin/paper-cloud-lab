FROM python:3.13-slim-bullseye

LABEL maintainer="Franklin D <devsecfranklin@duck.com>"
LABEL org.opencontainers.image.source="https://github.com/devsecfranklin/paper-cloud-lab"
LABEL org.opencontainers.image.description="Cloudlab Paper"
LABEL org.opencontainers.image.licenses=MIT

# %%%%% PACKAGES %%%%%
RUN ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime
RUN apt update && apt install -y tzdata bash
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt install -y texlive-full python3-pygments latexmk

# %%%%% ENVIRONMENT %%%%%
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONUNBUFFERED 1
ENV APP_ROOT=/home/franklin
WORKDIR ${APP_ROOT}
ENV USER_NAME=franklin \
    USER_UID=9001

# %%%%% USER SETUP %%%%%
RUN useradd -l -u ${USER_UID} -r -g 0 -d ${APP_ROOT} -s /bin/bash -c "${USER_NAME} user" ${USER_NAME} 
COPY . ${APP_ROOT}


# %%%%% GENERATE DOCUMENT %%%%%
RUN cd ${APP_ROOT} \
    && time \
    && make docker \
    && time

# Chown files in local home dir
RUN chown -R ${USER_NAME}:${USER_UID} ${APP_ROOT} \
    && chmod -R g=u ${APP_ROOT}

CMD latexmk -pvc -pdf -view=none -silent -time cloudlab.tex
