# Deber 03 – Ingesta, Construcción y Análisis OBT (One Big Table)

**Estudiante:** Giselle Cevallos

**Codigo Banner:** 00325549



### Descripción General

Este proyecto implementa un flujo completo de ingeniería de datos usando Apache Spark y Snowflake, basado en el dataset público de NYC Taxi Trips.  


### Estructura del Proyecto

| Notebook | Descripción |
|-----------|--------------|
| 01_ingesta_raw.ipynb | Descarga y carga de archivos Parquet (yellow y green taxi) hacia el esquema RAW en Snowflake. Incluye control de idempotencia y registro en RAW.INGEST_AUDIT. |
| 02_03_enriquecimiento_obt.ipynb | Lectura desde RAW, unión y enriquecimiento con zonas geográficas y catálogos (vendor, ratecode, payment). Construcción de la tabla final ANALYTICS.TRIPS_ENRICHED. |
| 04_calidad_auditoria.ipynb | Evaluación de calidad de datos: duplicados, nulos y consistencia de tipos. Verificación de registros en RAW.INGEST_AUDIT. |
| 05_analisis_consultas.ipynb | Consultas analíticas con Spark SQL: promedios de distancia, montos, propinas, tipos de servicio y comparaciones por método de pago. |


### Diagrama




## 🔐 Variables de Entorno (.env)

Estas variables garantizan la conexión segura y reproducible entre Spark y Snowflake:

```bash
SNOWFLAKE_ACCOUNT=xxxxxxxx
SNOWFLAKE_USER=xxxxxxxx
SNOWFLAKE_PASSWORD=xxxxxxxx
SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_DATABASE=NYCTAXI
SNOWFLAKE_SCHEMA_RAW=RAW
PARQUET_BASE_URL=https://d37ci6vzurychx.cloudfront.net/trip-data
