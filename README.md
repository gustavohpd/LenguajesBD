# Instalation guide

Esto asumiendo que ya tienes instalado Oracle Database 21c

### Pasos para instalar la extension de Oracle en xampp

- Descargar PHP Version 8.2.12
- Descargar Oracle Instant Client version 21_19 [aqui](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html)

## Instalar Oracle Instant Client

### 1. Descargar paquetes

- instantclient-basic-windows.x64-21.x.zip
- instantclient-sdk-windows.x64-21.x.zip

### 2. Extraer ambos ZIP

Extraer en:
C:\ORACLE\instantclient_21

### 3. Agregar al PATH

Agregar en Variables de entorno

- Variables del sistema agregar en path: C:\ORACLE\instantclient_21_19
- Crear nueva Variable del sistema con nombre OCI_LIB64 y Valor de la variable: C:\ORACLE\instantclient_21_19\

## Editar php.ini

- Buscar oci8 y agregar esto:

  ```bash
  extension=php_oci8_19.dll
  ```

  y luego se guarda.

# Crear conexion con VS

**Importante, el proyecto debe de estar en la carpeta htdocs de la carpeta xampp para que no de fallos.**
