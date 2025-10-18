FROM jupyter/pyspark-notebook:latest

USER root

# Copiar los jars del conector
RUN mkdir -p /usr/local/spark/jars
COPY jars/* /usr/local/spark/jars/

# Configuración de idioma
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Instalar librerías Python requeridas
RUN pip install --no-cache-dir \
    python-dotenv \
    snowflake-connector-python[pandas] \
    snowflake-sqlalchemy

USER ${NB_UID}
WORKDIR /home/jovyan/notebooks
