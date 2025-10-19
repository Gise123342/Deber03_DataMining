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
<img width="849" height="492" alt="image" src="https://github.com/user-attachments/assets/abbd5fe8-40d4-426a-8dd6-60d77b141a1d" />

### Matriz de cobertura 2015–2025 por servicio/mes (ok/falta/fallido).
<img width="1251" height="513" alt="image" src="https://github.com/user-attachments/assets/59c030e5-f8ce-4778-b1a5-a461f6890f63" />

### Pasos para Docker Compose y ejecución de notebooks (orden y parámetros).

**Clonar el repositorio**

bash
git clone https://github.com/Gise123342/Deber03_DataMining.git
cd Deber03_DataMining

**Levantar el entorno Docker**

docker compose up -d

Esto inicia un contenedor con Spark + Jupyter + dependencias necesarias.
Accede al entorno desde:
http://localhost:8888
 (class123)

**Encontraras todos los nootebooks de esta forma:**

<img width="1199" height="816" alt="image" src="https://github.com/user-attachments/assets/251bc673-c9ef-4a7d-ae15-f7fa08410a55" />

**Ejecución de notebooks (orden y parámetros)**

Ejecutar en numerologia 01, 02_03, 04, 05

En Notebook 02_03 no es necesario ejecutar bloque 01 y 02 ya que se utilizo para limpieza de memoria interna

<img width="674" height="435" alt="image" src="https://github.com/user-attachments/assets/8f149b45-4755-4fe4-8de9-7e11605f786f" />

Empezar desde el bloque 03 

<img width="688" height="560" alt="image" src="https://github.com/user-attachments/assets/d4f9b475-d155-49aa-9d67-b6b2c2f1205f" />

De igual forma el bloque 11 se utilizo para limpieza de datos antiguos con ayuda de chat GPT (no ejecutar )

<img width="624" height="631" alt="image" src="https://github.com/user-attachments/assets/83b4c178-052c-4747-8716-9dde0f504505" />

Tampoco necesario de ejecutar bloque 12 y 13 ya que se utilizo para la validacion de la limpieza

<img width="613" height="274" alt="image" src="https://github.com/user-attachments/assets/07b77c0b-e5e9-4c09-9900-2dd7cb159582" />

Aparte de los mencionados, todos los bloques se ejecutan en secuencia y son importantes de ejecutar 

### Variables de ambiente: listado y propósito; guía para .env.

Estas variables garantizan la conexión segura y reproducible entre Spark y Snowflake. Ademas que son incluidas en la raiz y no directamente en los notebooks para seguridad de credenciales y datos:

<img width="701" height="685" alt="image" src="https://github.com/user-attachments/assets/6940e4c4-9615-4691-83d2-ca70cb372865" />

Estas variables ya estan conectadas dentro de los notebooks para poder ingresar a bdd y usar datos

### Diseño de raw y OBT (columnas, derivadas, metadatos, supuestos).

**Esquema RAW**

Tablas: RAW.YELLOW_YYYY_MM, RAW.GREEN_YYYY_MM, INGEST_AUDIT

Columnas: directas del Parquet (pickup/dropoff, fare, tip, etc.)

Metadatos añadidos:
- service_type
- source_year
- source_month
- run_id
- ingested_at_utc
- source_path

**Esquema ANALYTICS (OBT)**

Tabla: ANALYTICS.TRIPS_ENRICHED

Columnas derivadas:
- vendor_name (según VendorID)
- rate_code_desc
- payment_type_desc
- pu_borough, pu_zone, do_borough, do_zone (join con lookup)

Finalidad: permitir análisis directos sin joins adicionales.

### Calidad/auditoría: qué se valida y dónde se ve.

| Validación              | Descripción                                                               | Ubicación   |
| ----------------------- | ------------------------------------------------------------------------- | ----------- |
| Duplicados          | Se comparan conteos con y sin `dropDuplicates()`                          | Notebook 04 |
| Nulos              | Conteo de `nulls` por columna                                             | Notebook 04 |
| Auditoría de cargas | Registro en `RAW.INGEST_AUDIT` con `run_id`, `rows_ingested`, `timestamp` | Notebook 01 |
| **Verificación final**  | Comparación entre filas RAW vs ANALYTICS                                  | Notebook 04 |

