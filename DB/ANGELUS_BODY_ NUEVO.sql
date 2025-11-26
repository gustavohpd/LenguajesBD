CREATE OR REPLACE PACKAGE BODY FIDE_ANGELUS_FINAL_PCK AS

-- =========================
-- FIDE_ESTADOS_TB
-- =========================
PROCEDURE FIDE_ESTADOS_INSERTAR_SP (
  p_estado_id     IN FIDE_ESTADOS_TB.ESTADO_ID%TYPE,
  p_nombre_estado IN FIDE_ESTADOS_TB.NOMBRE_ESTADO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_ESTADOS_TB (ESTADO_ID, NOMBRE_ESTADO)
  VALUES (p_estado_id, p_nombre_estado);
  DBMS_OUTPUT.PUT_LINE('Estado insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar estado.');
END;

PROCEDURE FIDE_ESTADOS_MODIFICAR_SP (
  p_estado_id     IN FIDE_ESTADOS_TB.ESTADO_ID%TYPE,
  p_nombre_estado IN FIDE_ESTADOS_TB.NOMBRE_ESTADO%TYPE
) IS
BEGIN
  UPDATE FIDE_ESTADOS_TB
     SET NOMBRE_ESTADO = p_nombre_estado
   WHERE ESTADO_ID = p_estado_id;
  DBMS_OUTPUT.PUT_LINE('Estado modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar estado.');
END;

-- =========================
-- FIDE_ROLES_TB
-- =========================
PROCEDURE FIDE_ROLES_INSERTAR_SP (
  p_rol_id     IN FIDE_ROLES_TB.ROL_ID%TYPE,
  p_estado_id  IN FIDE_ROLES_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre_rol IN FIDE_ROLES_TB.NOMBRE_ROL%TYPE
) IS
BEGIN
  INSERT INTO FIDE_ROLES_TB (ROL_ID, ESTADO_ID, NOMBRE_ROL)
  VALUES (p_rol_id, p_estado_id, p_nombre_rol);
  DBMS_OUTPUT.PUT_LINE('Rol insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar rol.');
END;

PROCEDURE FIDE_ROLES_MODIFICAR_SP (
  p_rol_id     IN FIDE_ROLES_TB.ROL_ID%TYPE,
  p_estado_id  IN FIDE_ROLES_TB.ESTADO_ID%TYPE,
  p_nombre_rol IN FIDE_ROLES_TB.NOMBRE_ROL%TYPE
) IS
BEGIN
  UPDATE FIDE_ROLES_TB
     SET ESTADO_ID = p_estado_id,
         NOMBRE_ROL = p_nombre_rol
   WHERE ROL_ID = p_rol_id;
  DBMS_OUTPUT.PUT_LINE('Rol modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar rol.');
END;

PROCEDURE FIDE_ROLES_ELIMINAR_SP (
  p_rol_id IN FIDE_ROLES_TB.ROL_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_ROLES_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE ROL_ID = p_rol_id;
  DBMS_OUTPUT.PUT_LINE('Rol eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar rol.');
END;

-- =========================
-- FIDE_CORREOS_TB
-- =========================
PROCEDURE FIDE_CORREOS_INSERTAR_SP (
  p_correo_id IN FIDE_CORREOS_TB.CORREO_ID%TYPE,
  p_estado_id IN FIDE_CORREOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_correo    IN FIDE_CORREOS_TB.CORREO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CORREOS_TB (CORREO_ID, ESTADO_ID, CORREO)
  VALUES (p_correo_id, p_estado_id, p_correo);
  DBMS_OUTPUT.PUT_LINE('Correo insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar correo.');
END;

PROCEDURE FIDE_CORREOS_MODIFICAR_SP (
  p_correo_id IN FIDE_CORREOS_TB.CORREO_ID%TYPE,
  p_estado_id IN FIDE_CORREOS_TB.ESTADO_ID%TYPE,
  p_correo    IN FIDE_CORREOS_TB.CORREO%TYPE
) IS
BEGIN
  UPDATE FIDE_CORREOS_TB
     SET ESTADO_ID = p_estado_id,
         CORREO    = p_correo
   WHERE CORREO_ID = p_correo_id;
  DBMS_OUTPUT.PUT_LINE('Correo modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar correo.');
END;

PROCEDURE FIDE_CORREOS_ELIMINAR_SP (
  p_correo_id IN FIDE_CORREOS_TB.CORREO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CORREOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE CORREO_ID = p_correo_id;
  DBMS_OUTPUT.PUT_LINE('Correo eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar correo.');
END;

-- =========================
-- FIDE_TELEFONOS_TB
-- =========================
PROCEDURE FIDE_TELEFONOS_INSERTAR_SP (
  p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
  p_estado_id   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_telefono    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_TELEFONOS_TB (TELEFONO_ID, ESTADO_ID, TELEFONO)
  VALUES (p_telefono_id, p_estado_id, p_telefono);
  DBMS_OUTPUT.PUT_LINE('Teléfono insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar teléfono.');
END;

PROCEDURE FIDE_TELEFONOS_MODIFICAR_SP (
  p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
  p_estado_id   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE,
  p_telefono    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
) IS
BEGIN
  UPDATE FIDE_TELEFONOS_TB
     SET ESTADO_ID = p_estado_id,
         TELEFONO  = p_telefono
   WHERE TELEFONO_ID = p_telefono_id;
  DBMS_OUTPUT.PUT_LINE('Teléfono modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar teléfono.');
END;

PROCEDURE FIDE_TELEFONOS_ELIMINAR_SP (
  p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_TELEFONOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE TELEFONO_ID = p_telefono_id;
  DBMS_OUTPUT.PUT_LINE('Teléfono eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar teléfono.');
END;

-- =========================
-- FIDE_USUARIOS_TB
-- =========================
PROCEDURE FIDE_USUARIOS_INSERTAR_SP (
  p_usuario_id       IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE,
  p_rol_id           IN FIDE_USUARIOS_TB.ROL_ID%TYPE,
  p_correo_id        IN FIDE_USUARIOS_TB.CORREO_ID%TYPE,
  p_telefono_id      IN FIDE_USUARIOS_TB.TELEFONO_ID%TYPE,
  p_estado_id        IN FIDE_USUARIOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre           IN FIDE_USUARIOS_TB.NOMBRE%TYPE,
  p_apellido_paterno IN FIDE_USUARIOS_TB.APELLIDO_PATERNO%TYPE,
  p_apellido_materno IN FIDE_USUARIOS_TB.APELLIDO_MATERNO%TYPE,
  p_fecha_registro   IN FIDE_USUARIOS_TB.FECHA_REGISTRO%TYPE DEFAULT SYSDATE
) IS
BEGIN
  INSERT INTO FIDE_USUARIOS_TB
    (USUARIO_ID, ROL_ID, CORREO_ID, TELEFONO_ID, ESTADO_ID,
     NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_REGISTRO)
  VALUES
    (p_usuario_id, p_rol_id, p_correo_id, p_telefono_id, p_estado_id,
     p_nombre, p_apellido_paterno, p_apellido_materno, p_fecha_registro);
  DBMS_OUTPUT.PUT_LINE('Usuario insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar usuario.');
END;

PROCEDURE FIDE_USUARIOS_MODIFICAR_SP (
  p_usuario_id       IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE,
  p_rol_id           IN FIDE_USUARIOS_TB.ROL_ID%TYPE,
  p_correo_id        IN FIDE_USUARIOS_TB.CORREO_ID%TYPE,
  p_telefono_id      IN FIDE_USUARIOS_TB.TELEFONO_ID%TYPE,
  p_estado_id        IN FIDE_USUARIOS_TB.ESTADO_ID%TYPE,
  p_nombre           IN FIDE_USUARIOS_TB.NOMBRE%TYPE,
  p_apellido_paterno IN FIDE_USUARIOS_TB.APELLIDO_PATERNO%TYPE,
  p_apellido_materno IN FIDE_USUARIOS_TB.APELLIDO_MATERNO%TYPE,
  p_fecha_registro   IN FIDE_USUARIOS_TB.FECHA_REGISTRO%TYPE
) IS
BEGIN
  UPDATE FIDE_USUARIOS_TB
     SET ROL_ID           = p_rol_id,
         CORREO_ID        = p_correo_id,
         TELEFONO_ID      = p_telefono_id,
         ESTADO_ID        = p_estado_id,
         NOMBRE           = p_nombre,
         APELLIDO_PATERNO = p_apellido_paterno,
         APELLIDO_MATERNO = p_apellido_materno,
         FECHA_REGISTRO   = p_fecha_registro
   WHERE USUARIO_ID = p_usuario_id;
  DBMS_OUTPUT.PUT_LINE('Usuario modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar usuario.');
END;

PROCEDURE FIDE_USUARIOS_ELIMINAR_SP (
  p_usuario_id IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_USUARIOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE USUARIO_ID = p_usuario_id;
  DBMS_OUTPUT.PUT_LINE('Usuario eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar usuario.');
END;

-- =========================
-- FIDE_CLIENTES_TB
-- =========================
PROCEDURE FIDE_CLIENTES_INSERTAR_SP (
  p_cliente_id   IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
  p_usuario_id   IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
  p_estado_id    IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_preferencias IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
  p_historial    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CLIENTES_TB
    (CLIENTE_ID, USUARIO_ID, ESTADO_ID, PREFERENCIAS, HISTORIAL_TRATAMIENTOS)
  VALUES
    (p_cliente_id, p_usuario_id, p_estado_id, p_preferencias, p_historial);
  DBMS_OUTPUT.PUT_LINE('Cliente insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar cliente.');
END;

PROCEDURE FIDE_CLIENTES_MODIFICAR_SP (
  p_cliente_id   IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
  p_usuario_id   IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
  p_estado_id    IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE,
  p_preferencias IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
  p_historial    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
) IS
BEGIN
  UPDATE FIDE_CLIENTES_TB
     SET USUARIO_ID            = p_usuario_id,
         ESTADO_ID             = p_estado_id,
         PREFERENCIAS          = p_preferencias,
         HISTORIAL_TRATAMIENTOS = p_historial
   WHERE CLIENTE_ID = p_cliente_id;
  DBMS_OUTPUT.PUT_LINE('Cliente modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar cliente.');
END;

PROCEDURE FIDE_CLIENTES_ELIMINAR_SP (
  p_cliente_id IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CLIENTES_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE CLIENTE_ID = p_cliente_id;
  DBMS_OUTPUT.PUT_LINE('Cliente eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar cliente.');
END;

-- =========================
-- FIDE_PROVINCIAS_TB
-- =========================
PROCEDURE FIDE_PROVINCIAS_INSERTAR_SP (
  p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
  p_estado_id    IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre       IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
) IS
BEGIN
  INSERT INTO FIDE_PROVINCIAS_TB (PROVINCIA_ID, ESTADO_ID, NOMBRE_PROVINCIA)
  VALUES (p_provincia_id, p_estado_id, p_nombre);
  DBMS_OUTPUT.PUT_LINE('Provincia insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar provincia.');
END;

PROCEDURE FIDE_PROVINCIAS_MODIFICAR_SP (
  p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
  p_estado_id    IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE,
  p_nombre       IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
) IS
BEGIN
  UPDATE FIDE_PROVINCIAS_TB
     SET ESTADO_ID       = p_estado_id,
         NOMBRE_PROVINCIA = p_nombre
   WHERE PROVINCIA_ID = p_provincia_id;
  DBMS_OUTPUT.PUT_LINE('Provincia modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar provincia.');
END;

PROCEDURE FIDE_PROVINCIAS_ELIMINAR_SP (
  p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_PROVINCIAS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE PROVINCIA_ID = p_provincia_id;
  DBMS_OUTPUT.PUT_LINE('Provincia eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar provincia.');
END;

-- =========================
-- FIDE_CANTONES_TB
-- =========================
PROCEDURE FIDE_CANTONES_INSERTAR_SP (
  p_canton_id    IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
  p_provincia_id IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
  p_estado_id    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre       IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CANTONES_TB (CANTON_ID, PROVINCIA_ID, ESTADO_ID, NOMBRE_CANTON)
  VALUES (p_canton_id, p_provincia_id, p_estado_id, p_nombre);
  DBMS_OUTPUT.PUT_LINE('Cantón insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar cantón.');
END;

PROCEDURE FIDE_CANTONES_MODIFICAR_SP (
  p_canton_id    IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
  p_provincia_id IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
  p_estado_id    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE,
  p_nombre       IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
) IS
BEGIN
  UPDATE FIDE_CANTONES_TB
     SET PROVINCIA_ID = p_provincia_id,
         ESTADO_ID    = p_estado_id,
         NOMBRE_CANTON = p_nombre
   WHERE CANTON_ID = p_canton_id;
  DBMS_OUTPUT.PUT_LINE('Cantón modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar cantón.');
END;

PROCEDURE FIDE_CANTONES_ELIMINAR_SP (
  p_canton_id IN FIDE_CANTONES_TB.CANTON_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CANTONES_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE CANTON_ID = p_canton_id;
  DBMS_OUTPUT.PUT_LINE('Cantón eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar cantón.');
END;

-- =========================
-- FIDE_DISTRITOS_TB
-- =========================
PROCEDURE FIDE_DISTRITOS_INSERTAR_SP (
  p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
  p_canton_id   IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
  p_estado_id   IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre      IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_DISTRITOS_TB (DISTRITO_ID, CANTON_ID, ESTADO_ID, NOMBRE_DISTRITO)
  VALUES (p_distrito_id, p_canton_id, p_estado_id, p_nombre);
  DBMS_OUTPUT.PUT_LINE('Distrito insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar distrito.');
END;

PROCEDURE FIDE_DISTRITOS_MODIFICAR_SP (
  p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
  p_canton_id   IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
  p_estado_id   IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE,
  p_nombre      IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
) IS
BEGIN
  UPDATE FIDE_DISTRITOS_TB
     SET CANTON_ID       = p_canton_id,
         ESTADO_ID       = p_estado_id,
         NOMBRE_DISTRITO = p_nombre
   WHERE DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Distrito modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar distrito.');
END;

PROCEDURE FIDE_DISTRITOS_ELIMINAR_SP (
  p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_DISTRITOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Distrito eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar distrito.');
END;

-- =========================
-- FIDE_DIRECCIONES_TB
-- =========================
PROCEDURE FIDE_DIRECCIONES_INSERTAR_SP (
  p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
  p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE,
  p_estado_id   IN FIDE_DIRECCIONES_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_descripcion IN FIDE_DIRECCIONES_TB.DESCRIPCION%TYPE
) IS
BEGIN
  INSERT INTO FIDE_DIRECCIONES_TB
    (USUARIO_ID, DISTRITO_ID, ESTADO_ID, DESCRIPCION)
  VALUES
    (p_usuario_id, p_distrito_id, p_estado_id, p_descripcion);
  DBMS_OUTPUT.PUT_LINE('Dirección insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar dirección.');
END;

PROCEDURE FIDE_DIRECCIONES_MODIFICAR_SP (
  p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
  p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE,
  p_estado_id   IN FIDE_DIRECCIONES_TB.ESTADO_ID%TYPE,
  p_descripcion IN FIDE_DIRECCIONES_TB.DESCRIPCION%TYPE
) IS
BEGIN
  UPDATE FIDE_DIRECCIONES_TB
     SET ESTADO_ID   = p_estado_id,
         DESCRIPCION = p_descripcion
   WHERE USUARIO_ID  = p_usuario_id
     AND DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Dirección modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar dirección.');
END;

PROCEDURE FIDE_DIRECCIONES_ELIMINAR_SP (
  p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
  p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_DIRECCIONES_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE USUARIO_ID  = p_usuario_id
     AND DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Dirección eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar dirección.');
END;

-- =========================
-- FIDE_CATEGORIAS_TB
-- =========================
PROCEDURE FIDE_CATEGORIAS_INSERTAR_SP (
  p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
  p_estado_id    IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre       IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CATEGORIAS_TB (CATEGORIA_ID, ESTADO_ID, NOMBRE_CATEGORIA)
  VALUES (p_categoria_id, p_estado_id, p_nombre);
  DBMS_OUTPUT.PUT_LINE('Categoría insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar categoría.');
END;

PROCEDURE FIDE_CATEGORIAS_MODIFICAR_SP (
  p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
  p_estado_id    IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE,
  p_nombre       IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
) IS
BEGIN
  UPDATE FIDE_CATEGORIAS_TB
     SET ESTADO_ID       = p_estado_id,
         NOMBRE_CATEGORIA = p_nombre
   WHERE CATEGORIA_ID = p_categoria_id;
  DBMS_OUTPUT.PUT_LINE('Categoría modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar categoría.');
END;

PROCEDURE FIDE_CATEGORIAS_ELIMINAR_SP (
  p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CATEGORIAS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE CATEGORIA_ID = p_categoria_id;
  DBMS_OUTPUT.PUT_LINE('Categoría eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar categoría.');
END;

-- =========================
-- FIDE_SERVICIOS_TB
-- =========================
PROCEDURE FIDE_SERVICIOS_INSERTAR_SP (
  p_servicio_id  IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
  p_estado_id    IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_categoria_id IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
  p_nombre       IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
  p_descripcion  IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
  p_duracion     IN FIDE_SERVICIOS_TB.DURACION%TYPE,
  p_precio       IN FIDE_SERVICIOS_TB.PRECIO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_SERVICIOS_TB
    (SERVICIO_ID, ESTADO_ID, CATEGORIA_ID, NOMBRE, DESCRIPCION, DURACION, PRECIO)
  VALUES
    (p_servicio_id, p_estado_id, p_categoria_id, p_nombre, p_descripcion, p_duracion, p_precio);
  DBMS_OUTPUT.PUT_LINE('Servicio insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar servicio.');
END;

PROCEDURE FIDE_SERVICIOS_MODIFICAR_SP (
  p_servicio_id  IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
  p_estado_id    IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE,
  p_categoria_id IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
  p_nombre       IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
  p_descripcion  IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
  p_duracion     IN FIDE_SERVICIOS_TB.DURACION%TYPE,
  p_precio       IN FIDE_SERVICIOS_TB.PRECIO%TYPE
) IS
BEGIN
  UPDATE FIDE_SERVICIOS_TB
     SET ESTADO_ID   = p_estado_id,
         CATEGORIA_ID = p_categoria_id,
         NOMBRE      = p_nombre,
         DESCRIPCION = p_descripcion,
         DURACION    = p_duracion,
         PRECIO      = p_precio
   WHERE SERVICIO_ID = p_servicio_id;
  DBMS_OUTPUT.PUT_LINE('Servicio modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar servicio.');
END;

PROCEDURE FIDE_SERVICIOS_ELIMINAR_SP (
  p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_SERVICIOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE SERVICIO_ID = p_servicio_id;
  DBMS_OUTPUT.PUT_LINE('Servicio eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar servicio.');
END;

-- =========================
-- FIDE_CITAS_TB
-- =========================
PROCEDURE FIDE_CITAS_INSERTAR_SP (
  p_cita_id     IN FIDE_CITAS_TB.CITA_ID%TYPE,
  p_cliente_id  IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
  p_servicio_id IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
  p_estado_id   IN FIDE_CITAS_TB.ESTADO_ID%TYPE DEFAULT 3, -- Pendiente
  p_fecha_hora  IN FIDE_CITAS_TB.FECHA_HORA%TYPE,
  p_notas       IN FIDE_CITAS_TB.NOTAS%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CITAS_TB
    (CITA_ID, CLIENTE_ID, SERVICIO_ID, ESTADO_ID, FECHA_HORA, NOTAS)
  VALUES
    (p_cita_id, p_cliente_id, p_servicio_id, p_estado_id, p_fecha_hora, p_notas);
  DBMS_OUTPUT.PUT_LINE('Cita insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar cita.');
END;

PROCEDURE FIDE_CITAS_MODIFICAR_SP (
  p_cita_id     IN FIDE_CITAS_TB.CITA_ID%TYPE,
  p_cliente_id  IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
  p_servicio_id IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
  p_estado_id   IN FIDE_CITAS_TB.ESTADO_ID%TYPE,
  p_fecha_hora  IN FIDE_CITAS_TB.FECHA_HORA%TYPE,
  p_notas       IN FIDE_CITAS_TB.NOTAS%TYPE
) IS
BEGIN
  UPDATE FIDE_CITAS_TB
     SET CLIENTE_ID  = p_cliente_id,
         SERVICIO_ID = p_servicio_id,
         ESTADO_ID   = p_estado_id,
         FECHA_HORA  = p_fecha_hora,
         NOTAS       = p_notas
   WHERE CITA_ID = p_cita_id;
  DBMS_OUTPUT.PUT_LINE('Cita modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar cita.');
END;

PROCEDURE FIDE_CITAS_ELIMINAR_SP (
  p_cita_id IN FIDE_CITAS_TB.CITA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CITAS_TB
     SET ESTADO_ID = 5 -- Cancelado
   WHERE CITA_ID = p_cita_id;
  DBMS_OUTPUT.PUT_LINE('Cita eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar cita.');
END;

-- =========================
-- FIDE_PROVEEDORES_TB
-- =========================
PROCEDURE FIDE_PROVEEDORES_INSERTAR_SP (
  p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
  p_estado_id    IN FIDE_PROVEEDORES_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_telefono_id  IN FIDE_PROVEEDORES_TB.TELEFONO_ID%TYPE,
  p_nombre       IN FIDE_PROVEEDORES_TB.NOMBRE%TYPE,
  p_contacto     IN FIDE_PROVEEDORES_TB.CONTACTO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_PROVEEDORES_TB
    (PROVEEDOR_ID, ESTADO_ID, TELEFONO_ID, NOMBRE, CONTACTO)
  VALUES
    (p_proveedor_id, p_estado_id, p_telefono_id, p_nombre, p_contacto);
  DBMS_OUTPUT.PUT_LINE('Proveedor insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar proveedor.');
END;

PROCEDURE FIDE_PROVEEDORES_MODIFICAR_SP (
  p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
  p_estado_id    IN FIDE_PROVEEDORES_TB.ESTADO_ID%TYPE,
  p_telefono_id  IN FIDE_PROVEEDORES_TB.TELEFONO_ID%TYPE,
  p_nombre       IN FIDE_PROVEEDORES_TB.NOMBRE%TYPE,
  p_contacto     IN FIDE_PROVEEDORES_TB.CONTACTO%TYPE
) IS
BEGIN
  UPDATE FIDE_PROVEEDORES_TB
     SET ESTADO_ID   = p_estado_id,
         TELEFONO_ID = p_telefono_id,
         NOMBRE      = p_nombre,
         CONTACTO    = p_contacto
   WHERE PROVEEDOR_ID = p_proveedor_id;
  DBMS_OUTPUT.PUT_LINE('Proveedor modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar proveedor.');
END;

PROCEDURE FIDE_PROVEEDORES_ELIMINAR_SP (
  p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_PROVEEDORES_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE PROVEEDOR_ID = p_proveedor_id;
  DBMS_OUTPUT.PUT_LINE('Proveedor eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar proveedor.');
END;

-- =========================
-- FIDE_PRODUCTOS_TB
-- =========================
PROCEDURE FIDE_PRODUCTOS_INSERTAR_SP (
  p_producto_id  IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
  p_categoria_id IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
  p_estado_id    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_proveedor_id IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
  p_nombre       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
  p_descripcion  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
  p_precio       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_PRODUCTOS_TB
    (PRODUCTO_ID, CATEGORIA_ID, ESTADO_ID, PROVEEDOR_ID, NOMBRE, DESCRIPCION, PRECIO)
  VALUES
    (p_producto_id, p_categoria_id, p_estado_id, p_proveedor_id, p_nombre, p_descripcion, p_precio);
  DBMS_OUTPUT.PUT_LINE('Producto insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar producto.');
END;

PROCEDURE FIDE_PRODUCTOS_MODIFICAR_SP (
  p_producto_id  IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
  p_categoria_id IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
  p_estado_id    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE,
  p_proveedor_id IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
  p_nombre       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
  p_descripcion  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
  p_precio       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE
) IS
BEGIN
  UPDATE FIDE_PRODUCTOS_TB
     SET CATEGORIA_ID = p_categoria_id,
         ESTADO_ID    = p_estado_id,
         PROVEEDOR_ID = p_proveedor_id,
         NOMBRE       = p_nombre,
         DESCRIPCION  = p_descripcion,
         PRECIO       = p_precio
   WHERE PRODUCTO_ID = p_producto_id;
  DBMS_OUTPUT.PUT_LINE('Producto modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar producto.');
END;

PROCEDURE FIDE_PRODUCTOS_ELIMINAR_SP (
  p_producto_id IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_PRODUCTOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE PRODUCTO_ID = p_producto_id;
  DBMS_OUTPUT.PUT_LINE('Producto eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar producto.');
END;

-- =========================
-- FIDE_INVENTARIO_TB
-- =========================
PROCEDURE FIDE_INVENTARIO_INSERTAR_SP (
  p_producto_id IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
  p_estado_id   IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_cantidad    IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE,
  p_fecha_act   IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE DEFAULT SYSDATE
) IS
BEGIN
  INSERT INTO FIDE_INVENTARIO_TB
    (PRODUCTO_ID, ESTADO_ID, CANTIDAD, FECHA_ACTUALIZACION)
  VALUES
    (p_producto_id, p_estado_id, p_cantidad, p_fecha_act);
  DBMS_OUTPUT.PUT_LINE('Inventario insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar inventario.');
END;

PROCEDURE FIDE_INVENTARIO_MODIFICAR_SP (
  p_producto_id IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
  p_fecha_act   IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE,
  p_estado_id   IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE,
  p_cantidad    IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE
) IS
BEGIN
  UPDATE FIDE_INVENTARIO_TB
     SET ESTADO_ID          = p_estado_id,
         CANTIDAD           = p_cantidad
   WHERE PRODUCTO_ID        = p_producto_id
     AND FECHA_ACTUALIZACION = p_fecha_act;
  DBMS_OUTPUT.PUT_LINE('Inventario modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar inventario.');
END;

PROCEDURE FIDE_INVENTARIO_ELIMINAR_SP (
  p_producto_id IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
  p_fecha_act   IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE
) IS
BEGIN
  UPDATE FIDE_INVENTARIO_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE PRODUCTO_ID        = p_producto_id
     AND FECHA_ACTUALIZACION = p_fecha_act;
  DBMS_OUTPUT.PUT_LINE('Inventario eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar inventario.');
END;

-- =========================
-- FIDE_METODOS_PAGO_TB
-- =========================
PROCEDURE FIDE_METODOS_PAGO_INSERTAR_SP (
  p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE,
  p_estado_id      IN FIDE_METODOS_PAGO_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre_metodo  IN FIDE_METODOS_PAGO_TB.NOMBRE_METODO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_METODOS_PAGO_TB
    (METODO_PAGO_ID, ESTADO_ID, NOMBRE_METODO)
  VALUES
    (p_metodo_pago_id, p_estado_id, p_nombre_metodo);
  DBMS_OUTPUT.PUT_LINE('Método de pago insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar método de pago.');
END;

PROCEDURE FIDE_METODOS_PAGO_MODIFICAR_SP (
  p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE,
  p_estado_id      IN FIDE_METODOS_PAGO_TB.ESTADO_ID%TYPE,
  p_nombre_metodo  IN FIDE_METODOS_PAGO_TB.NOMBRE_METODO%TYPE
) IS
BEGIN
  UPDATE FIDE_METODOS_PAGO_TB
     SET ESTADO_ID     = p_estado_id,
         NOMBRE_METODO = p_nombre_metodo
   WHERE METODO_PAGO_ID = p_metodo_pago_id;
  DBMS_OUTPUT.PUT_LINE('Método de pago modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar método de pago.');
END;

PROCEDURE FIDE_METODOS_PAGO_ELIMINAR_SP (
  p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_METODOS_PAGO_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE METODO_PAGO_ID = p_metodo_pago_id;
  DBMS_OUTPUT.PUT_LINE('Método de pago eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar método de pago.');
END;

-- =========================
-- FIDE_FACTURAS_TB
-- =========================
PROCEDURE FIDE_FACTURAS_INSERTAR_SP (
  p_factura_id     IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
  p_cliente_id     IN FIDE_FACTURAS_TB.CLIENTE_ID%TYPE,
  p_estado_id      IN FIDE_FACTURAS_TB.ESTADO_ID%TYPE DEFAULT 8, -- Facturado
  p_metodo_pago_id IN FIDE_FACTURAS_TB.METODO_PAGO_ID%TYPE,
  p_fecha          IN FIDE_FACTURAS_TB.FECHA%TYPE,
  p_impuestos      IN FIDE_FACTURAS_TB.IMPUESTOS%TYPE,
  p_total          IN FIDE_FACTURAS_TB.TOTAL%TYPE
) IS
BEGIN
  INSERT INTO FIDE_FACTURAS_TB
    (FACTURA_ID, CLIENTE_ID, ESTADO_ID, METODO_PAGO_ID, FECHA, IMPUESTOS, TOTAL)
  VALUES
    (p_factura_id, p_cliente_id, p_estado_id, p_metodo_pago_id, p_fecha, p_impuestos, p_total);
  DBMS_OUTPUT.PUT_LINE('Factura insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar factura.');
END;

PROCEDURE FIDE_FACTURAS_MODIFICAR_SP (
  p_factura_id     IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
  p_cliente_id     IN FIDE_FACTURAS_TB.CLIENTE_ID%TYPE,
  p_estado_id      IN FIDE_FACTURAS_TB.ESTADO_ID%TYPE,
  p_metodo_pago_id IN FIDE_FACTURAS_TB.METODO_PAGO_ID%TYPE,
  p_fecha          IN FIDE_FACTURAS_TB.FECHA%TYPE,
  p_impuestos      IN FIDE_FACTURAS_TB.IMPUESTOS%TYPE,
  p_total          IN FIDE_FACTURAS_TB.TOTAL%TYPE
) IS
BEGIN
  UPDATE FIDE_FACTURAS_TB
     SET CLIENTE_ID     = p_cliente_id,
         ESTADO_ID      = p_estado_id,
         METODO_PAGO_ID = p_metodo_pago_id,
         FECHA          = p_fecha,
         IMPUESTOS      = p_impuestos,
         TOTAL          = p_total
   WHERE FACTURA_ID = p_factura_id;
  DBMS_OUTPUT.PUT_LINE('Factura modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar factura.');
END;

PROCEDURE FIDE_FACTURAS_ELIMINAR_SP (
  p_factura_id IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_FACTURAS_TB
     SET ESTADO_ID = 5 -- Cancelado
   WHERE FACTURA_ID = p_factura_id;
  DBMS_OUTPUT.PUT_LINE('Factura eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar factura.');
END;

-- =========================
-- FIDE_DETALLES_FACTURA_TB
-- =========================
PROCEDURE FIDE_DETALLES_FACTURA_INSERTAR_SP (
  p_factura_id   IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
  p_servicio_id  IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
  p_producto_id  IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE,
  p_estado_id    IN FIDE_DETALLES_FACTURA_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_precio_unit  IN FIDE_DETALLES_FACTURA_TB.PRECIO_UNITARIO%TYPE,
  p_cantidad     IN FIDE_DETALLES_FACTURA_TB.CANTIDAD%TYPE
) IS
BEGIN
  INSERT INTO FIDE_DETALLES_FACTURA_TB
    (FACTURA_ID, SERVICIO_ID, PRODUCTO_ID, ESTADO_ID, PRECIO_UNITARIO, CANTIDAD)
  VALUES
    (p_factura_id, p_servicio_id, p_producto_id, p_estado_id, p_precio_unit, p_cantidad);
  DBMS_OUTPUT.PUT_LINE('Detalle de factura insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar detalle de factura.');
END;

PROCEDURE FIDE_DETALLES_FACTURA_MODIFICAR_SP (
  p_factura_id   IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
  p_servicio_id  IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
  p_producto_id  IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE,
  p_estado_id    IN FIDE_DETALLES_FACTURA_TB.ESTADO_ID%TYPE,
  p_precio_unit  IN FIDE_DETALLES_FACTURA_TB.PRECIO_UNITARIO%TYPE,
  p_cantidad     IN FIDE_DETALLES_FACTURA_TB.CANTIDAD%TYPE
) IS
BEGIN
  UPDATE FIDE_DETALLES_FACTURA_TB
     SET ESTADO_ID       = p_estado_id,
         PRECIO_UNITARIO = p_precio_unit,
         CANTIDAD        = p_cantidad
   WHERE FACTURA_ID  = p_factura_id
     AND SERVICIO_ID = p_servicio_id
     AND PRODUCTO_ID = p_producto_id;
  DBMS_OUTPUT.PUT_LINE('Detalle de factura modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar detalle de factura.');
END;

PROCEDURE FIDE_DETALLES_FACTURA_ELIMINAR_SP (
  p_factura_id   IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
  p_servicio_id  IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
  p_producto_id  IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_DETALLES_FACTURA_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE FACTURA_ID  = p_factura_id
     AND SERVICIO_ID = p_servicio_id
     AND PRODUCTO_ID = p_producto_id;
  DBMS_OUTPUT.PUT_LINE('Detalle de factura eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar detalle de factura.');
END;

-- =========================
-- FIDE_DIRECCIONES_PROVEEDORES_TB 
-- =========================
PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_INSERTAR_SP (
  p_proveedor_id IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
  p_distrito_id  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  INSERT INTO FIDE_DIRECCIONES_PROVEEDORES_TB (PROVEEDOR_ID, DISTRITO_ID)
  VALUES (p_proveedor_id, p_distrito_id);
  DBMS_OUTPUT.PUT_LINE('Dirección de proveedor insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar dirección de proveedor.');
END;

PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_MODIFICAR_SP (
  p_proveedor_id       IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
  p_distrito_id        IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE,
  p_nuevo_proveedor_id IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
  p_nuevo_distrito_id  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_DIRECCIONES_PROVEEDORES_TB
     SET PROVEEDOR_ID = p_nuevo_proveedor_id,
         DISTRITO_ID  = p_nuevo_distrito_id
   WHERE PROVEEDOR_ID = p_proveedor_id
     AND DISTRITO_ID  = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Dirección de proveedor modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar dirección de proveedor.');
END;

END FIDE_ANGELUS_FINAL_PCK;
/