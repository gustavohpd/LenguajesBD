create or replace PACKAGE FIDE_ANGELUS_ESTETICA_PKG AS
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
-- PROCEDIMIENTOS PAME
-- =========================
PROCEDURE FIDE_CLIENTES_LISTAR_SP (
  p_cursor OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PROCEDURE FIDE_CLIENTES_OBTENER_SP (
  p_cliente_id IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
  p_cursor OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_OBTENER_TODOS_SP (
  p_cursor OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_OBTENER_POR_ID_SP (
  p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
  p_cursor OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_OBTENER_SP (
  p_producto_id   IN  FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
  p_categoria_id  OUT FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
  p_estado_id     OUT FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE,
  p_proveedor_id  OUT FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
  p_nombre        OUT FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
  p_descripcion   OUT FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
  p_precio        OUT FIDE_PRODUCTOS_TB.PRECIO%TYPE
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_LISTAR_SP (
    p_cursor OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =========================
-- PROCEDIMIENTOS Melissa
-- =========================

  -- =========================
  -- FIDE_ESTADOS_TB
  -- =========================
  PROCEDURE FIDE_ESTADOS_INSERTAR_SP (
    p_estado_id     IN FIDE_ESTADOS_TB.ESTADO_ID%TYPE,
    p_nombre_estado IN FIDE_ESTADOS_TB.NOMBRE_ESTADO%TYPE
  );

  PROCEDURE FIDE_ESTADOS_MODIFICAR_SP (
    p_estado_id     IN FIDE_ESTADOS_TB.ESTADO_ID%TYPE,
    p_nombre_estado IN FIDE_ESTADOS_TB.NOMBRE_ESTADO%TYPE
  );

  -- =========================
  -- FIDE_ROLES_TB
  -- =========================
  PROCEDURE FIDE_ROLES_INSERTAR_SP (
    p_rol_id     IN FIDE_ROLES_TB.ROL_ID%TYPE,
    p_estado_id  IN FIDE_ROLES_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre_rol IN FIDE_ROLES_TB.NOMBRE_ROL%TYPE
  );

  PROCEDURE FIDE_ROLES_MODIFICAR_SP (
    p_rol_id     IN FIDE_ROLES_TB.ROL_ID%TYPE,
    p_estado_id  IN FIDE_ROLES_TB.ESTADO_ID%TYPE,
    p_nombre_rol IN FIDE_ROLES_TB.NOMBRE_ROL%TYPE
  );

  PROCEDURE FIDE_ROLES_ELIMINAR_SP (
    p_rol_id IN FIDE_ROLES_TB.ROL_ID%TYPE
  );

  -- =========================
  -- FIDE_CORREOS_TB
  -- =========================
  PROCEDURE FIDE_CORREOS_INSERTAR_SP (
    p_correo_id IN FIDE_CORREOS_TB.CORREO_ID%TYPE,
    p_estado_id IN FIDE_CORREOS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_correo    IN FIDE_CORREOS_TB.CORREO%TYPE
  );

  PROCEDURE FIDE_CORREOS_MODIFICAR_SP (
    p_correo_id IN FIDE_CORREOS_TB.CORREO_ID%TYPE,
    p_estado_id IN FIDE_CORREOS_TB.ESTADO_ID%TYPE,
    p_correo    IN FIDE_CORREOS_TB.CORREO%TYPE
  );

  PROCEDURE FIDE_CORREOS_ELIMINAR_SP (
    p_correo_id IN FIDE_CORREOS_TB.CORREO_ID%TYPE
  );

  -- =========================
  -- FIDE_TELEFONOS_TB
  -- =========================
  PROCEDURE FIDE_TELEFONOS_INSERTAR_SP (
    p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
    p_estado_id   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_telefono    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
  );

  PROCEDURE FIDE_TELEFONOS_MODIFICAR_SP (
    p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
    p_estado_id   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE,
    p_telefono    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
  );

  PROCEDURE FIDE_TELEFONOS_ELIMINAR_SP (
    p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE
  );

  -- =========================
  -- FIDE_USUARIOS_TB
  -- =========================
  PROCEDURE FIDE_USUARIOS_INSERTAR_SP (
    p_usuario_id       IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE,
    p_rol_id           IN FIDE_USUARIOS_TB.ROL_ID%TYPE,
    p_correo_id        IN FIDE_USUARIOS_TB.CORREO_ID%TYPE,
    p_telefono_id      IN FIDE_USUARIOS_TB.TELEFONO_ID%TYPE,
    p_estado_id        IN FIDE_USUARIOS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre           IN FIDE_USUARIOS_TB.NOMBRE%TYPE,
    p_apellido_paterno IN FIDE_USUARIOS_TB.APELLIDO_PATERNO%TYPE,
    p_apellido_materno IN FIDE_USUARIOS_TB.APELLIDO_MATERNO%TYPE,
    p_fecha_registro   IN FIDE_USUARIOS_TB.FECHA_REGISTRO%TYPE DEFAULT SYSDATE
  );

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
  );

  PROCEDURE FIDE_USUARIOS_ELIMINAR_SP (
    p_usuario_id IN FIDE_USUARIOS_TB.USUARIO_ID%TYPE
  );

  -- =========================
  -- FIDE_CLIENTES_TB
  -- =========================
  PROCEDURE FIDE_CLIENTES_INSERTAR_SP (
    p_cliente_id   IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
    p_usuario_id   IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
    p_estado_id    IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_preferencias IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
    p_historial    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
  );

  PROCEDURE FIDE_CLIENTES_MODIFICAR_SP (
    p_cliente_id   IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
    p_usuario_id   IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
    p_estado_id    IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE,
    p_preferencias IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
    p_historial    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
  );

  PROCEDURE FIDE_CLIENTES_ELIMINAR_SP (
    p_cliente_id IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE
  );

  -- =========================
  -- FIDE_PROVINCIAS_TB
  -- =========================
  PROCEDURE FIDE_PROVINCIAS_INSERTAR_SP (
    p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
    p_estado_id    IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre       IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
  );

  PROCEDURE FIDE_PROVINCIAS_MODIFICAR_SP (
    p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
    p_estado_id    IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE,
    p_nombre       IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
  );

  PROCEDURE FIDE_PROVINCIAS_ELIMINAR_SP (
    p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE
  );

  -- =========================
  -- FIDE_CANTONES_TB
  -- =========================
  PROCEDURE FIDE_CANTONES_INSERTAR_SP (
    p_canton_id    IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
    p_provincia_id IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
    p_estado_id    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre       IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
  );

  PROCEDURE FIDE_CANTONES_MODIFICAR_SP (
    p_canton_id    IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
    p_provincia_id IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
    p_estado_id    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE,
    p_nombre       IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
  );

  PROCEDURE FIDE_CANTONES_ELIMINAR_SP (
    p_canton_id IN FIDE_CANTONES_TB.CANTON_ID%TYPE
  );

  -- =========================
  -- FIDE_DISTRITOS_TB
  -- =========================
  PROCEDURE FIDE_DISTRITOS_INSERTAR_SP (
    p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
    p_canton_id   IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
    p_estado_id   IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre      IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
  );

  PROCEDURE FIDE_DISTRITOS_MODIFICAR_SP (
    p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
    p_canton_id   IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
    p_estado_id   IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE,
    p_nombre      IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
  );

  PROCEDURE FIDE_DISTRITOS_ELIMINAR_SP (
    p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE
  );

  -- =========================
  -- FIDE_DIRECCIONES_TB
  -- =========================
  PROCEDURE FIDE_DIRECCIONES_INSERTAR_SP (
    p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
    p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE,
    p_estado_id   IN FIDE_DIRECCIONES_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_descripcion IN FIDE_DIRECCIONES_TB.DESCRIPCION%TYPE
  );

  PROCEDURE FIDE_DIRECCIONES_MODIFICAR_SP (
    p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
    p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE,
    p_estado_id   IN FIDE_DIRECCIONES_TB.ESTADO_ID%TYPE,
    p_descripcion IN FIDE_DIRECCIONES_TB.DESCRIPCION%TYPE
  );

  PROCEDURE FIDE_DIRECCIONES_ELIMINAR_SP (
    p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
    p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE
  );

  -- =========================
  -- FIDE_CATEGORIAS_TB
  -- =========================
  PROCEDURE FIDE_CATEGORIAS_INSERTAR_SP (
    p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
    p_estado_id    IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre       IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
  );

  PROCEDURE FIDE_CATEGORIAS_MODIFICAR_SP (
    p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
    p_estado_id    IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE,
    p_nombre       IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
  );

  PROCEDURE FIDE_CATEGORIAS_ELIMINAR_SP (
    p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE
  );

  -- =========================
  -- FIDE_SERVICIOS_TB
  -- =========================
  PROCEDURE FIDE_SERVICIOS_INSERTAR_SP (
    p_servicio_id  IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
    p_estado_id    IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_categoria_id IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
    p_nombre       IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
    p_descripcion  IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
    p_duracion     IN FIDE_SERVICIOS_TB.DURACION%TYPE,
    p_precio       IN FIDE_SERVICIOS_TB.PRECIO%TYPE
  );

  PROCEDURE FIDE_SERVICIOS_MODIFICAR_SP (
    p_servicio_id  IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
    p_estado_id    IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE,
    p_categoria_id IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
    p_nombre       IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
    p_descripcion  IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
    p_duracion     IN FIDE_SERVICIOS_TB.DURACION%TYPE,
    p_precio       IN FIDE_SERVICIOS_TB.PRECIO%TYPE
  );

  PROCEDURE FIDE_SERVICIOS_ELIMINAR_SP (
    p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE
  );

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
  );

  PROCEDURE FIDE_CITAS_MODIFICAR_SP (
    p_cita_id     IN FIDE_CITAS_TB.CITA_ID%TYPE,
    p_cliente_id  IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
    p_servicio_id IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
    p_estado_id   IN FIDE_CITAS_TB.ESTADO_ID%TYPE,
    p_fecha_hora  IN FIDE_CITAS_TB.FECHA_HORA%TYPE,
    p_notas       IN FIDE_CITAS_TB.NOTAS%TYPE
  );

  PROCEDURE FIDE_CITAS_ELIMINAR_SP (
    p_cita_id IN FIDE_CITAS_TB.CITA_ID%TYPE
  );

  -- =========================
  -- FIDE_PROVEEDORES_TB
  -- =========================
  PROCEDURE FIDE_PROVEEDORES_INSERTAR_SP (
    p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    p_estado_id    IN FIDE_PROVEEDORES_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_telefono_id  IN FIDE_PROVEEDORES_TB.TELEFONO_ID%TYPE,
    p_nombre       IN FIDE_PROVEEDORES_TB.NOMBRE%TYPE,
    p_contacto     IN FIDE_PROVEEDORES_TB.CONTACTO%TYPE
  );

  PROCEDURE FIDE_PROVEEDORES_MODIFICAR_SP (
    p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    p_estado_id    IN FIDE_PROVEEDORES_TB.ESTADO_ID%TYPE,
    p_telefono_id  IN FIDE_PROVEEDORES_TB.TELEFONO_ID%TYPE,
    p_nombre       IN FIDE_PROVEEDORES_TB.NOMBRE%TYPE,
    p_contacto     IN FIDE_PROVEEDORES_TB.CONTACTO%TYPE
  );

  PROCEDURE FIDE_PROVEEDORES_ELIMINAR_SP (
    p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE
  );

  -- =========================
  -- FIDE_PRODUCTOS_TB
  -- =========================
  PROCEDURE FIDE_PRODUCTOS_INSERTAR_SP (
    p_producto_id  IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
    p_categoria_id IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
    p_estado_id    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_proveedor_id IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
    p_nombre       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
    p_descripcion  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
    p_precio       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE
  );

  PROCEDURE FIDE_PRODUCTOS_MODIFICAR_SP (
    p_producto_id  IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
    p_categoria_id IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
    p_estado_id    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE,
    p_proveedor_id IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
    p_nombre       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
    p_descripcion  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
    p_precio       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE
  );

  PROCEDURE FIDE_PRODUCTOS_ELIMINAR_SP (
    p_producto_id IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE
  );

  -- =========================
  -- FIDE_INVENTARIO_TB
  -- =========================
  PROCEDURE FIDE_INVENTARIO_INSERTAR_SP (
    p_producto_id IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
    p_estado_id   IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_cantidad    IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE,
    p_fecha_act   IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE DEFAULT SYSDATE
  );

  PROCEDURE FIDE_INVENTARIO_MODIFICAR_SP (
    p_producto_id IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
    p_fecha_act   IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE,
    p_estado_id   IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE,
    p_cantidad    IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE
  );

  PROCEDURE FIDE_INVENTARIO_ELIMINAR_SP (
    p_producto_id IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
    p_fecha_act   IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE
  );

  -- =========================
  -- FIDE_METODOS_PAGO_TB
  -- =========================
  PROCEDURE FIDE_METODOS_PAGO_INSERTAR_SP (
    p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE,
    p_estado_id      IN FIDE_METODOS_PAGO_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_nombre_metodo  IN FIDE_METODOS_PAGO_TB.NOMBRE_METODO%TYPE
  );

  PROCEDURE FIDE_METODOS_PAGO_MODIFICAR_SP (
    p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE,
    p_estado_id      IN FIDE_METODOS_PAGO_TB.ESTADO_ID%TYPE,
    p_nombre_metodo  IN FIDE_METODOS_PAGO_TB.NOMBRE_METODO%TYPE
  );

  PROCEDURE FIDE_METODOS_PAGO_ELIMINAR_SP (
    p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE
  );

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
  );

  PROCEDURE FIDE_FACTURAS_MODIFICAR_SP (
    p_factura_id     IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
    p_cliente_id     IN FIDE_FACTURAS_TB.CLIENTE_ID%TYPE,
    p_estado_id      IN FIDE_FACTURAS_TB.ESTADO_ID%TYPE,
    p_metodo_pago_id IN FIDE_FACTURAS_TB.METODO_PAGO_ID%TYPE,
    p_fecha          IN FIDE_FACTURAS_TB.FECHA%TYPE,
    p_impuestos      IN FIDE_FACTURAS_TB.IMPUESTOS%TYPE,
    p_total          IN FIDE_FACTURAS_TB.TOTAL%TYPE
  );

  PROCEDURE FIDE_FACTURAS_ELIMINAR_SP (
    p_factura_id IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE
  );

  -- =========================
  -- FIDE_DETALLES_FACTURA_TB
  -- =========================
  PROCEDURE FIDE_DETALLES_FACTURA_INSERTAR_SP (
    p_factura_id   IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
    p_servicio_id  IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
    p_producto_id  IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE,
    p_estado_id    IN FIDE_DETALLES_FACTURA_TB.ESTADO_ID%TYPE DEFAULT 1, -- Activo
    p_precio_unit  IN FIDE_DETALLES_FACTURA_TB.PRECIO_UNITARIO%TYPE,
    p_cantidad     IN FIDE_DETALLES_FACTURA_TB.CANTIDAD%TYPE
  );

  PROCEDURE FIDE_DETALLES_FACTURA_MODIFICAR_SP (
    p_factura_id   IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
    p_servicio_id  IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
    p_producto_id  IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE,
    p_estado_id    IN FIDE_DETALLES_FACTURA_TB.ESTADO_ID%TYPE,
    p_precio_unit  IN FIDE_DETALLES_FACTURA_TB.PRECIO_UNITARIO%TYPE,
    p_cantidad     IN FIDE_DETALLES_FACTURA_TB.CANTIDAD%TYPE
  );

  PROCEDURE FIDE_DETALLES_FACTURA_ELIMINAR_SP (
    p_factura_id   IN FIDE_DETALLES_FACTURA_TB.FACTURA_ID%TYPE,
    p_servicio_id  IN FIDE_DETALLES_FACTURA_TB.SERVICIO_ID%TYPE,
    p_producto_id  IN FIDE_DETALLES_FACTURA_TB.PRODUCTO_ID%TYPE
  );

  -- =========================
  -- FIDE_DIRECCIONES_PROVEEDORES_TB
  -- =========================
  PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_INSERTAR_SP (
    p_proveedor_id IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    p_distrito_id  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
  );

  PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_MODIFICAR_SP (
    p_proveedor_id       IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    p_distrito_id        IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE,
    p_nuevo_proveedor_id IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
    p_nuevo_distrito_id  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
  );

END FIDE_ANGELUS_ESTETICA_PKG;