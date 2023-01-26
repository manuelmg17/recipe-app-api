FROM python:3.9-alpine3.13
LABEL maintainer="manuelmansilla"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

#The variable DEV is being overwritten on the docker-compose.yml
#This makes it so when we are on another machine the value will be asigned
#to false, but true on our local machine. 
#We do this so we dont install fake8 on our deployed application

#When we use the apk add... --virtual option we are creating a group
#with the dependencies, so when we delete deps we are deleting them all
#(becasue they are only needed for installation, but not for use,
#this way we keep our docker lightweight)

ARG DEV=false 
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client &&\
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps &&\
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user