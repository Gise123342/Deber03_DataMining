# Deber 03 – Ingesta, Construcción y Análisis OBT (One Big Table)

**Estudiante:** Giselle Cevallos

**Codigo Banner:** 00325549


**Carpeta de evidencias ( estara en el ultimo iteral de readme con fotos):**

Capturas de Compose corriendo, servicios ejecutándose y
conectados, conteos por lote, snapshot de OBT.


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
| Duplicados          | Se comparan conteos con y sin dropDuplicates()                          | Notebook 04 |
| Nulos              | Conteo de nulls por columna                                             | Notebook 04 |
| Auditoría de cargas | Registro en RAW.INGEST_AUDIT con run_id, rows_ingested, timestamp | Notebook 01 |
| Verificación final  | Comparación entre filas RAW vs ANALYTICS                                  | Notebook 04 |

**Registro de auditoria**
| service_type | year | month | run_id                   | rows_ingested | logged_at_utc        |
| ------------ | ---- | ----- | ------------------------ | ------------- | -------------------- |
| yellow       | 2019 | 01    | p3_run_20251017_235900 | 193982        | 2025-10-17T23:59:00Z |

### Carpeta de evidencias

**Compose con servicio:** 
<img width="1551" height="140" alt="image" src="https://github.com/user-attachments/assets/f65277cb-030b-4917-87c3-ff11e263b815" />

**Nootebook 01:**
<img width="1187" height="816" alt="image" src="https://github.com/user-attachments/assets/ea191055-d197-48d8-8003-4d0cb215a04b" />
<img width="954" height="818" alt="image" src="https://github.com/user-attachments/assets/eb457c17-f364-4bca-8c34-9230a19f1110" />
<img width="980" height="811" alt="image" src="https://github.com/user-attachments/assets/fdd3105e-ea71-4c4f-bc37-45ccc1b1ac19" />
<img width="917" height="842" alt="image" src="https://github.com/user-attachments/assets/6e3f1ebc-db2e-4629-8747-3220b3dee025" />
<img width="1048" height="844" alt="image" src="https://github.com/user-attachments/assets/3a46b42d-da73-4759-a977-6af0d03563ae" />
<img width="907" height="822" alt="image" src="https://github.com/user-attachments/assets/8ae27e1e-ba75-4c30-8f95-b81d9efb8cdb" />
<img width="958" height="815" alt="image" src="https://github.com/user-attachments/assets/382dcb27-cd49-4f5a-8828-9dcaab8dda34" />
<img width="967" height="802" alt="image" src="https://github.com/user-attachments/assets/a5ec0fb6-f6fc-4220-b2fe-d934becef7b3" />

**Nootebook 02:**

<img width="1033" height="831" alt="image" src="https://github.com/user-attachments/assets/a37ca12e-aabc-446a-9eec-7f1da18ee265" />
<img width="988" height="840" alt="image" src="https://github.com/user-attachments/assets/94a8a111-7f03-45db-b904-ff4b0caebd1f" />
<img width="946" height="822" alt="image" src="https://github.com/user-attachments/assets/a51d7fc6-b294-4eca-8e95-cb3bde4b4267" />
<img width="946" height="818" alt="image" src="https://github.com/user-attachments/assets/8ad2a9b9-0157-4223-aa0c-a5a034f8b150" />
<img width="1054" height="829" alt="image" src="https://github.com/user-attachments/assets/1cc05545-932f-4cd3-9a9d-5ee5afb6b77b" />
<img width="1017" height="837" alt="image" src="https://github.com/user-attachments/assets/173b923b-1481-4814-a74f-729001654eae" />
<img width="992" height="837" alt="image" src="https://github.com/user-attachments/assets/0e392f08-a823-4477-8ee4-a5ea39bb1fe4" />
<img width="1169" height="829" alt="image" src="https://github.com/user-attachments/assets/1a571055-78e5-4390-b447-9c8b21f155eb" />
<img width="960" height="824" alt="image" src="https://github.com/user-attachments/assets/3f907191-6931-48a1-a461-ca90347316c1" />
<img width="1008" height="823" alt="image" src="https://github.com/user-attachments/assets/5fd6a07d-c436-42ab-8086-121235a56081" />
<img width="1304" height="827" alt="image" src="https://github.com/user-attachments/assets/2cbc3b03-13fc-4732-baca-c10431f7573a" />
<img width="1086" height="830" alt="image" src="https://github.com/user-attachments/assets/bf3af81b-f289-40dd-b35b-94194cf80386" />
<img width="1109" height="798" alt="image" src="https://github.com/user-attachments/assets/342c8554-7d65-4741-b7fb-33db11c7f682" />


**Tablas en snowflake**

Raw
<img width="1222" height="815" alt="image" src="https://github.com/user-attachments/assets/daf4fbe5-dfa4-431c-bbef-8ad5d5dd7b75" />
<img width="1230" height="744" alt="image" src="https://github.com/user-attachments/assets/0163df8b-6184-4193-98de-bf7e721590e5" />
<img width="1241" height="566" alt="image" src="https://github.com/user-attachments/assets/aea611f2-7d90-430c-b76a-715ff3e81543" />

Analitys

<img width="1272" height="801" alt="image" src="https://github.com/user-attachments/assets/7927e880-b13d-4604-89c4-48984f20ab89" />
<img width="1090" height="886" alt="image" src="https://github.com/user-attachments/assets/dcccd0e7-9076-481b-8ac2-796f62530704" />

Para mejor observacion visualizar en el proyecto en notebooks 








