--------------------------------------------------------
-- Archivo creado  - jueves-noviembre-20-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package FIDE_ANGELUS_ESTETICA_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "ANGELUS"."FIDE_ANGELUS_ESTETICA_PKG" AS
-- =========================
-- FUNCIONES
-- =========================
FUNCTION FIDE_USUARIOS_OBTENER_NOMBRE_USUARIO_FN(
    P_USUARIO_ID IN NUMBER
) RETURN VARCHAR2;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_CORREOS_OBTENER_CORREO_USUARIO_FN(
    P_USUARIO_ID IN NUMBER
) RETURN VARCHAR2;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_DETALLES_FACTURA_TOTAL_FACTURA_FN(
    P_FACTURA_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_CITAS_CITA_DISPONIBLE_FN(
    P_FECHA_HORA IN TIMESTAMP,
    P_SERVICIO_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_INVENTARIO_STOCK_PRODUCTO_FN(
    P_PRODUCTO_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_PRODUCTOS_ESTADO_TEXTO_FN(
    P_ESTADO_ID IN NUMBER
) RETURN VARCHAR2;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_FACTURAS_TOTAL_VENTAS_CLIENTE_FN(
    P_CLIENTE_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_CITAS_POR_DIA_FN(
    P_FECHA IN DATE
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_DIRECCIONES_DIRECCION_USUARIO_FN(
    P_USUARIO_ID IN NUMBER
) RETURN VARCHAR2;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_SERVICIOS_POR_CATEGORIA_FN(
    P_CATEGORIA_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_PRODUCTOS_POR_PROVEEDOR_FN(
    P_PROVEEDOR_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FIDE_CLIENTES_EXISTE_FN(
    P_CLIENTE_ID IN NUMBER
) RETURN NUMBER;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =========================
-- PROCEDIMIENTOS ALMACENADOS
-- =========================
-- =========================
-- FIDE_ESTADOS_TB
-- =========================
PROCEDURE FIDE_ESTADOS_TB_INSERT_SP(
    P_ESTADO_ID     IN FIDE_ESTADOS_TB.ESTADO_ID%TYPE,
    P_NOMBRE_ESTADO IN FIDE_ESTADOS_TB.NOMBRE_ESTADO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_ESTADOS_TB_UPDATE_SP(
    P_ESTADO_ID     IN FIDE_ESTADOS_TB.ESTADO_ID%TYPE,
    P_NOMBRE_ESTADO IN FIDE_ESTADOS_TB.NOMBRE_ESTADO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_ROLES_TB
-- =========================
PROCEDURE FIDE_ROLES_TB_INSERT_SP(
    P_ROL_ID     IN FIDE_ROLES_TB.ROL_ID%TYPE,
    P_ESTADO_ID  IN FIDE_ROLES_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE_ROL IN FIDE_ROLES_TB.NOMBRE_ROL%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_ROLES_TB_UPDATE_SP(
    P_ROL_ID     IN FIDE_ROLES_TB.ROL_ID%TYPE,
    P_ESTADO_ID  IN FIDE_ROLES_TB.ESTADO_ID%TYPE,
    P_NOMBRE_ROL IN FIDE_ROLES_TB.NOMBRE_ROL%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_ROLES_TB_DELETE_SP(
    P_ROL_ID IN FIDE_ROLES_TB.ROL_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_CORREOS_TB
-- =========================
PROCEDURE FIDE_CORREOS_TB_INSERT_SP(
    P_CORREO_ID IN FIDE_CORREOS_TB.CORREO_ID%TYPE,
    P_ESTADO_ID IN FIDE_CORREOS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_CORREO    IN FIDE_CORREOS_TB.CORREO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CORREOS_TB_UPDATE_SP(
    P_CORREO_ID IN FIDE_CORREOS_TB.CORREO_ID%TYPE,
    P_ESTADO_ID IN FIDE_CORREOS_TB.ESTADO_ID%TYPE,
    P_CORREO    IN FIDE_CORREOS_TB.CORREO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CORREOS_TB_DELETE_SP(
    P_CORREO_ID IN FIDE_CORREOS_TB.CORREO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_TELEFONOS_TB
-- =========================
PROCEDURE FIDE_TELEFONOS_TB_INSERT_SP(
    P_TELEFONO_ID IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_TELEFONO    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_TELEFONOS_TB_UPDATE_SP(
    P_TELEFONO_ID IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE,
    P_TELEFONO    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_TELEFONOS_TB_DELETE_SP(
    P_TELEFONO_ID IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_USUARIOS_TB
-- =========================
PROCEDURE FIDE_USUARIOS_TB_INSERT_SP(
    P_USUARIO_ID       IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE,
    P_ROL_ID           IN FIDE_USUARIOS_TB.ROL_ID%TYPE,
    P_CORREO_ID        IN FIDE_USUARIOS_TB.CORREO_ID%TYPE,
    P_TELEFONO_ID      IN FIDE_USUARIOS_TB.TELEFONO_ID%TYPE,
    P_ESTADO_ID        IN FIDE_USUARIOS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE           IN FIDE_USUARIOS_TB.NOMBRE%TYPE,
    P_APELLIDO_PATERNO IN FIDE_USUARIOS_TB.APELLIDO_PATERNO%TYPE,
    P_APELLIDO_MATERNO IN FIDE_USUARIOS_TB.APELLIDO_MATERNO%TYPE,
    P_FECHA_REGISTRO   IN FIDE_USUARIOS_TB.FECHA_REGISTRO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_USUARIOS_TB_UPDATE_SP(
    P_USUARIO_ID       IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE,
    P_ROL_ID           IN FIDE_USUARIOS_TB.ROL_ID%TYPE,
    P_CORREO_ID        IN FIDE_USUARIOS_TB.CORREO_ID%TYPE,
    P_TELEFONO_ID      IN FIDE_USUARIOS_TB.TELEFONO_ID%TYPE,
    P_ESTADO_ID        IN FIDE_USUARIOS_TB.ESTADO_ID%TYPE,
    P_NOMBRE           IN FIDE_USUARIOS_TB.NOMBRE%TYPE,
    P_APELLIDO_PATERNO IN FIDE_USUARIOS_TB.APELLIDO_PATERNO%TYPE,
    P_APELLIDO_MATERNO IN FIDE_USUARIOS_TB.APELLIDO_MATERNO%TYPE,
    P_FECHA_REGISTRO   IN FIDE_USUARIOS_TB.FECHA_REGISTRO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_USUARIOS_TB_DELETE_SP(
    P_USUARIO_ID IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_CLIENTES_TB
-- =========================
PROCEDURE FIDE_CLIENTES_TB_INSERT_SP(
    P_CLIENTE_ID IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
    P_USUARIO_ID IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
    P_ESTADO_ID  IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_PREFERENCIAS IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
    P_HISTORIAL    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CLIENTES_TB_UPDATE_SP(
    P_CLIENTE_ID IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
    P_USUARIO_ID IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
    P_ESTADO_ID  IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE,
    P_PREFERENCIAS IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
    P_HISTORIAL    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CLIENTES_TB_DELETE_SP(
    P_CLIENTE_ID IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_PROVINCIAS_TB
-- =========================
PROCEDURE FIDE_PROVINCIAS_TB_INSERT_SP(
    P_PROVINCIA_ID   IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
    P_ESTADO_ID      IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE         IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVINCIAS_TB_UPDATE_SP(
    P_PROVINCIA_ID   IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
    P_ESTADO_ID      IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE,
    P_NOMBRE         IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVINCIAS_TB_DELETE_SP(
    P_PROVINCIA_ID IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_CANTONES_TB
-- =========================
PROCEDURE FIDE_CANTONES_TB_INSERT_SP(
    P_CANTON_ID   IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
    P_PROVINCIA_ID IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
    P_ESTADO_ID    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE       IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CANTONES_TB_UPDATE_SP(
    P_CANTON_ID   IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
    P_PROVINCIA_ID IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
    P_ESTADO_ID    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE,
    P_NOMBRE       IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CANTONES_TB_DELETE_SP(
    P_CANTON_ID IN FIDE_CANTONES_TB.CANTON_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_DISTRITOS_TB
-- =========================
PROCEDURE FIDE_DISTRITOS_TB_INSERT_SP(
    P_DISTRITO_ID IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
    P_CANTON_ID   IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
    P_ESTADO_ID   IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE      IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DISTRITOS_TB_UPDATE_SP(
    P_DISTRITO_ID IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
    P_CANTON_ID   IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
    P_ESTADO_ID   IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE,
    P_NOMBRE      IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DISTRITOS_TB_DELETE_SP(
    P_DISTRITO_ID IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_DIRECCIONES_TB
-- =========================
PROCEDURE FIDE_DIRECCIONES_TB_INSERT_SP(
    P_USUARIO_ID  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
    P_DISTRITO_ID IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_DIRECCIONES_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_DESCRIPCION IN FIDE_DIRECCIONES_TB.DESCRIPCION%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DIRECCIONES_TB_UPDATE_SP(
    P_USUARIO_ID  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
    P_DISTRITO_ID IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_DIRECCIONES_TB.ESTADO_ID%TYPE,
    P_DESCRIPCION IN FIDE_DIRECCIONES_TB.DESCRIPCION%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DIRECCIONES_TB_DELETE_SP(
    P_USUARIO_ID  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
    P_DISTRITO_ID IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_CATEGORIAS_TB
-- =========================
PROCEDURE FIDE_CATEGORIAS_TB_INSERT_SP(
    P_CATEGORIA_ID IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
    P_ESTADO_ID    IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE       IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_TB_UPDATE_SP(
    P_CATEGORIA_ID IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
    P_ESTADO_ID    IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE,
    P_NOMBRE       IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_TB_DELETE_SP(
    P_CATEGORIA_ID IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_SERVICIOS_TB
-- =========================
PROCEDURE FIDE_SERVICIOS_TB_INSERT_SP(
    P_SERVICIO_ID IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_CATEGORIA_ID IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
    P_NOMBRE      IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
    P_DESCRIPCION IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
    P_DURACION    IN FIDE_SERVICIOS_TB.DURACION%TYPE,
    P_PRECIO      IN FIDE_SERVICIOS_TB.PRECIO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_TB_UPDATE_SP(
    P_SERVICIO_ID IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE,
    P_CATEGORIA_ID IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
    P_NOMBRE      IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
    P_DESCRIPCION IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
    P_DURACION    IN FIDE_SERVICIOS_TB.DURACION%TYPE,
    P_PRECIO      IN FIDE_SERVICIOS_TB.PRECIO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_TB_DELETE_SP(
    P_SERVICIO_ID IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_CITAS_TB
-- =========================
PROCEDURE FIDE_CITAS_TB_INSERT_SP(
    P_CITA_ID     IN FIDE_CITAS_TB.CITA_ID%TYPE,
    P_CLIENTE_ID  IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
    P_SERVICIO_ID IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_CITAS_TB.ESTADO_ID%TYPE DEFAULT 3,
    P_FECHA_HORA  IN FIDE_CITAS_TB.FECHA_HORA%TYPE,
    P_NOTAS       IN FIDE_CITAS_TB.NOTAS%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CITAS_TB_UPDATE_SP(
    P_CITA_ID     IN FIDE_CITAS_TB.CITA_ID%TYPE,
    P_CLIENTE_ID  IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
    P_SERVICIO_ID IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
    P_ESTADO_ID   IN FIDE_CITAS_TB.ESTADO_ID%TYPE,
    P_FECHA_HORA  IN FIDE_CITAS_TB.FECHA_HORA%TYPE,
    P_NOTAS       IN FIDE_CITAS_TB.NOTAS%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CITAS_TB_DELETE_SP(
    P_CITA_ID IN FIDE_CITAS_TB.CITA_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_PROVEEDORES_TB
-- =========================
PROCEDURE FIDE_PROVEEDORES_TB_INSERT_SP(
    P_PROVEEDOR_ID IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    P_ESTADO_ID    IN FIDE_PROVEEDORES_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_TELEFONO_ID  IN FIDE_PROVEEDORES_TB.TELEFONO_ID%TYPE,
    P_NOMBRE       IN FIDE_PROVEEDORES_TB.NOMBRE%TYPE,
    P_CONTACTO     IN FIDE_PROVEEDORES_TB.CONTACTO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVEEDORES_TB_UPDATE_SP(
    P_PROVEEDOR_ID IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    P_ESTADO_ID    IN FIDE_PROVEEDORES_TB.ESTADO_ID%TYPE,
    P_TELEFONO_ID  IN FIDE_PROVEEDORES_TB.TELEFONO_ID%TYPE,
    P_NOMBRE       IN FIDE_PROVEEDORES_TB.NOMBRE%TYPE,
    P_CONTACTO     IN FIDE_PROVEEDORES_TB.CONTACTO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVEEDORES_TB_DELETE_SP(
    P_PROVEEDOR_ID IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_PRODUCTOS_TB
-- =========================
PROCEDURE FIDE_PRODUCTOS_TB_INSERT_SP(
    P_PRODUCTO_ID IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
    P_CATEGORIA_ID IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
    P_ESTADO_ID    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_PROVEEDOR_ID IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
    P_NOMBRE       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
    P_DESCRIPCION  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
    P_PRECIO       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_TB_UPDATE_SP(
    P_PRODUCTO_ID IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
    P_CATEGORIA_ID IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
    P_ESTADO_ID    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE,
    P_PROVEEDOR_ID IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
    P_NOMBRE       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
    P_DESCRIPCION  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
    P_PRECIO       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_TB_DELETE_SP(
    P_PRODUCTO_ID IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_INVENTARIO_TB
-- =========================
PROCEDURE FIDE_INVENTARIO_TB_INSERT_SP(
    P_INVENTARIO_ID IN FIDE_INVENTARIO_TB.INVENTARIO_ID%TYPE,
    P_PRODUCTO_ID   IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
    P_ESTADO_ID     IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_CANTIDAD      IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE,
    P_FECHA_ACT     IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_TB_UPDATE_SP(
    P_INVENTARIO_ID IN FIDE_INVENTARIO_TB.INVENTARIO_ID%TYPE,
    P_PRODUCTO_ID   IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
    P_ESTADO_ID     IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE,
    P_CANTIDAD      IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE,
    P_FECHA_ACT     IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_TB_DELETE_SP(
    P_INVENTARIO_ID IN FIDE_INVENTARIO_TB.INVENTARIO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_METODOS_PAGO_TB
-- =========================
PROCEDURE FIDE_METODOS_PAGO_TB_INSERT_SP(
    P_METODO_PAGO_ID IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE,
    P_ESTADO_ID      IN FIDE_METODOS_PAGO_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_NOMBRE_METODO  IN FIDE_METODOS_PAGO_TB.NOMBRE_METODO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_METODOS_PAGO_TB_UPDATE_SP(
    P_METODO_PAGO_ID IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE,
    P_ESTADO_ID      IN FIDE_METODOS_PAGO_TB.ESTADO_ID%TYPE,
    P_NOMBRE_METODO  IN FIDE_METODOS_PAGO_TB.NOMBRE_METODO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_METODOS_PAGO_TB_DELETE_SP(
    P_METODO_PAGO_ID IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_FACTURAS_TB
-- =========================
PROCEDURE FIDE_FACTURAS_TB_INSERT_SP(
    P_FACTURA_ID     IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
    P_CLIENTE_ID     IN FIDE_FACTURAS_TB.CLIENTE_ID%TYPE,
    P_ESTADO_ID      IN FIDE_FACTURAS_TB.ESTADO_ID%TYPE DEFAULT 8,
    P_METODO_PAGO_ID IN FIDE_FACTURAS_TB.METODO_PAGO_ID%TYPE,
    P_FECHA          IN FIDE_FACTURAS_TB.FECHA%TYPE,
    P_IMPUESTOS      IN FIDE_FACTURAS_TB.IMPUESTOS%TYPE,
    P_TOTAL          IN FIDE_FACTURAS_TB.TOTAL%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_FACTURAS_TB_UPDATE_SP(
    P_FACTURA_ID     IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
    P_CLIENTE_ID     IN FIDE_FACTURAS_TB.CLIENTE_ID%TYPE,
    P_ESTADO_ID      IN FIDE_FACTURAS_TB.ESTADO_ID%TYPE,
    P_METODO_PAGO_ID IN FIDE_FACTURAS_TB.METODO_PAGO_ID%TYPE,
    P_FECHA          IN FIDE_FACTURAS_TB.FECHA%TYPE,
    P_IMPUESTOS      IN FIDE_FACTURAS_TB.IMPUESTOS%TYPE,
    P_TOTAL          IN FIDE_FACTURAS_TB.TOTAL%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_FACTURAS_TB_DELETE_SP(
    P_FACTURA_ID IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_DETALLES_FACTURA_TB
-- =========================
PROCEDURE FIDE_DETALLES_FACTURA_TB_INSERT_SP(
    P_DETALLE_ID    IN FIDE_DETALLES_FACTURA_TB.DETALLE_ID%TYPE,
    P_FACTURA_ID    IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
    P_SERVICIO_ID   IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
    P_PRODUCTO_ID   IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE,
    P_ESTADO_ID     IN FIDE_DETALLES_FACTURA_TB.ESTADO_ID%TYPE DEFAULT 1,
    P_PRECIO_UNIT   IN FIDE_DETALLES_FACTURA_TB.PRECIO_UNITARIO%TYPE,
    P_CANTIDAD      IN FIDE_DETALLES_FACTURA_TB.CANTIDAD%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DETALLES_FACTURA_TB_UPDATE_SP(
    P_DETALLE_ID    IN FIDE_DETALLES_FACTURA_TB.DETALLE_ID%TYPE,
    P_FACTURA_ID    IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
    P_SERVICIO_ID   IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
    P_PRODUCTO_ID   IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE,
    P_ESTADO_ID     IN FIDE_DETALLES_FACTURA_TB.ESTADO_ID%TYPE,
    P_PRECIO_UNIT   IN FIDE_DETALLES_FACTURA_TB.PRECIO_UNITARIO%TYPE,
    P_CANTIDAD      IN FIDE_DETALLES_FACTURA_TB.CANTIDAD%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DETALLES_FACTURA_TB_DELETE_SP(
    P_DETALLE_ID IN FIDE_DETALLES_FACTURA_TB.DETALLE_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- FIDE_DIRECCIONES_PROVEEDORES_TB
-- =========================
PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_TB_INSERT_SP(
    P_PROVEEDOR_ID IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    P_DISTRITO_ID  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_TB_UPDATE_SP(
    P_PROVEEDOR_ID IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    P_DISTRITO_ID  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE,
    P_NUEVO_PROVEEDOR_ID IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    P_NUEVO_DISTRITO_ID  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

END FIDE_ANGELUS_ESTETICA_PKG;

/
