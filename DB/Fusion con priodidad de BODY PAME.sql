--------------------------------------------------------
-- Archivo creado  - viernes-diciembre-12-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body FIDE_ANGELUS_ESTETICA_PKG
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ANGELUS_ESTETICA"."FIDE_ANGELUS_ESTETICA_PKG" AS

-- =========================
-- FUNCIONES
-- =========================
FUNCTION USUARIOS_OBTENER_NOMBRE_USUARIO_FN(
    P_USUARIO_ID NUMBER
) RETURN VARCHAR2 IS
    V_NOMBRE_COMPLETO VARCHAR2(300);
    
    ---- El cursor va a buscar el usuario en la base
    CURSOR C_USUARIO IS
        SELECT NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO
        FROM FIDE_USUARIOS_TB
        WHERE USUARIO_ID = P_USUARIO_ID
        AND ESTADO_ID = 1; 
    V_ENCONTRADO BOOLEAN := FALSE;

BEGIN
    FOR REGISTRO IN C_USUARIO LOOP
        V_ENCONTRADO := TRUE;
        
        ----Se verifica si tiene apellido materno y se construye el nombre en consecuencia
        IF REGISTRO.APELLIDO_MATERNO IS NOT NULL THEN
            V_NOMBRE_COMPLETO := REGISTRO.NOMBRE || ' ' || REGISTRO.APELLIDO_PATERNO || ' ' || REGISTRO.APELLIDO_MATERNO;
        ELSE
            V_NOMBRE_COMPLETO := REGISTRO.NOMBRE || ' ' || REGISTRO.APELLIDO_PATERNO;
        END IF;
    END LOOP;
    
    ----Si no se encontr� ning�n registro se muestra otro mensaje
    IF NOT V_ENCONTRADO THEN
        DBMS_OUTPUT.PUT_LINE('No se encontr� el usuario con ID: ' || P_USUARIO_ID);
        V_NOMBRE_COMPLETO := 'Usuario no encontrado';
    END IF;
    
    RETURN V_NOMBRE_COMPLETO;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        RETURN 'Error al buscar usuario';
END USUARIOS_OBTENER_NOMBRE_USUARIO_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CITAS_OBTENER_PENDIENTES_FN 
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    
    CURSOR C_CITAS_PENDIENTES IS
        SELECT      
            ci.CLIENTE_ID,
            ci.SERVICIO_ID,
            ci.FECHA_HORA,
            u.NOMBRE || ' ' || u.APELLIDO_PATERNO AS NOMBRE_CLIENTE,
            s.NOMBRE AS NOMBRE_SERVICIO,
            ci.NOTAS
        FROM FIDE_CITAS_TB ci
        JOIN FIDE_CLIENTES_TB cl ON ci.CLIENTE_ID = cl.CLIENTE_ID
        JOIN FIDE_USUARIOS_TB u ON cl.USUARIO_ID = u.USUARIO_ID
        JOIN FIDE_SERVICIOS_TB s ON ci.SERVICIO_ID = s.SERVICIO_ID
        WHERE ci.ESTADO_ID = 3 
        ORDER BY ci.FECHA_HORA ASC;
        
    V_CONTADOR NUMBER := 0;
BEGIN
    V_RESULTADO := 'CITAS PENDIENTES:' || CHR(10) || CHR(10);
    
    FOR REGISTRO IN C_CITAS_PENDIENTES LOOP
        V_CONTADOR := V_CONTADOR + 1;
        
        V_RESULTADO := V_RESULTADO || 
                     'Cita #' || V_CONTADOR || CHR(10) ||
                     'Cliente: ' || REGISTRO.NOMBRE_CLIENTE || CHR(10) ||
                     'Servicio: ' || REGISTRO.NOMBRE_SERVICIO || CHR(10) ||
                     'Fecha: ' || TO_CHAR(REGISTRO.FECHA_HORA, 'DD/MM/YYYY HH24:MI') || CHR(10) ||
                     'Notas: ' || NVL(REGISTRO.NOTAS, 'Sin notas') || CHR(10) ||
                     '------------------------------------' || CHR(10);
    END LOOP;
    
    IF V_CONTADOR = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay citas pendientes.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) || 'Total: ' || V_CONTADOR || ' citas pendientes';
    END IF;
    
    RETURN V_RESULTADO;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al obtener citas pendientes: ' || SQLERRM;
END CITAS_OBTENER_PENDIENTES_FN;
-------------------------------------------------------------------------------------------------
FUNCTION INVENTARIO_OBTENER_BAJO_STOCK_FN(
    P_MINIMO NUMBER DEFAULT 10
) RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    
    CURSOR C_PRODUCTOS_BAJO_STOCK IS
        SELECT 
            p.PRODUCTO_ID,
            p.NOMBRE AS PRODUCTO,
            i.CANTIDAD,
            cat.NOMBRE_CATEGORIA AS CATEGORIA,
            prov.NOMBRE AS PROVEEDOR
        FROM FIDE_PRODUCTOS_TB p
        JOIN FIDE_INVENTARIO_TB i ON p.PRODUCTO_ID = i.PRODUCTO_ID
        JOIN FIDE_CATEGORIAS_TB cat ON p.CATEGORIA_ID = cat.CATEGORIA_ID
        JOIN FIDE_PROVEEDORES_TB prov ON p.PROVEEDOR_ID = prov.PROVEEDOR_ID
        WHERE i.CANTIDAD <= P_MINIMO
        AND i.ESTADO_ID = 1
        AND p.ESTADO_ID = 1
        ORDER BY i.CANTIDAD ASC;
        
    V_CONTADOR NUMBER := 0;
BEGIN
    V_RESULTADO := 'PRODUCTOS CON BAJO STOCK (CANTIDAD M�NIMA: ' || P_MINIMO || '):' || CHR(10) || CHR(10);
    
    FOR REGISTRO IN C_PRODUCTOS_BAJO_STOCK LOOP
        V_CONTADOR := V_CONTADOR + 1;
        
        V_RESULTADO := V_RESULTADO || 
                     'Producto #' || V_CONTADOR || CHR(10) ||
                     'Nombre: ' || REGISTRO.PRODUCTO || CHR(10) ||
                     'Stock actual: ' || REGISTRO.CANTIDAD || CHR(10) ||
                     'Categor�a: ' || REGISTRO.CATEGORIA || CHR(10) ||
                     'Proveedor: ' || REGISTRO.PROVEEDOR || CHR(10) ||
                     '------------------------------------' || CHR(10);
    END LOOP;
    
    IF V_CONTADOR = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay productos con stock bajo.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) || 'Total: ' || V_CONTADOR || ' productos requieren atenci�n';
    END IF;
    
    RETURN V_RESULTADO;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al obtener productos con bajo stock: ' || SQLERRM;
END INVENTARIO_OBTENER_BAJO_STOCK_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CITAS_OBTENER_DEL_DIA_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    
    CURSOR C_CITAS_HOY IS
        SELECT 
            ci.CLIENTE_ID,
            ci.SERVICIO_ID,
            ci.FECHA_HORA,
            u.NOMBRE || ' ' || u.APELLIDO_PATERNO AS NOMBRE_CLIENTE,
            s.NOMBRE AS NOMBRE_SERVICIO,
            ci.NOTAS,
            e.NOMBRE_ESTADO AS ESTADO
        FROM FIDE_CITAS_TB ci
        JOIN FIDE_CLIENTES_TB cl ON ci.CLIENTE_ID = cl.CLIENTE_ID
        JOIN FIDE_USUARIOS_TB u ON cl.USUARIO_ID = u.USUARIO_ID
        JOIN FIDE_SERVICIOS_TB s ON ci.SERVICIO_ID = s.SERVICIO_ID
        JOIN FIDE_ESTADOS_TB e ON ci.ESTADO_ID = e.ESTADO_ID
        WHERE TRUNC(ci.FECHA_HORA) = TRUNC(SYSDATE)  
        AND ci.ESTADO_ID IN (1, 3) 
        ORDER BY ci.FECHA_HORA ASC;
        
    V_CONTADOR NUMBER := 0;
BEGIN
    V_RESULTADO := 'CITAS PROGRAMADAS PARA HOY (' || TO_CHAR(SYSDATE, 'DD/MM/YYYY') || '):' || CHR(10) || CHR(10);
    
    FOR REGISTRO IN C_CITAS_HOY LOOP
        V_CONTADOR := V_CONTADOR + 1;
        
        V_RESULTADO := V_RESULTADO || 
                     'Cita #' || V_CONTADOR || CHR(10) ||
                     'Hora: ' || TO_CHAR(REGISTRO.FECHA_HORA, 'HH24:MI') || CHR(10) ||
                     'Cliente: ' || REGISTRO.NOMBRE_CLIENTE || CHR(10) ||
                     'Servicio: ' || REGISTRO.NOMBRE_SERVICIO || CHR(10) ||
                     'Estado: ' || REGISTRO.ESTADO || CHR(10) ||
                     'Notas: ' || NVL(REGISTRO.NOTAS, 'Sin notas') || CHR(10) ||
                     '------------------------------------' || CHR(10);
    END LOOP;
    
    IF V_CONTADOR = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay citas programadas para hoy.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) || 'Total citas hoy: ' || V_CONTADOR;
    END IF;
    
    RETURN V_RESULTADO;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al obtener citas del d�a: ' || SQLERRM;
END CITAS_OBTENER_DEL_DIA_FN;
-------------------------------------------------------------------------------------------------
-- FUNCIONES FALTANTES DEL BODY2
-------------------------------------------------------------------------------------------------
FUNCTION FACTURAS_TB_SECUENCIA_FN
    RETURN NUMBER AS
    V_FECHA VARCHAR2(10);
    V_SECUENCIA NUMBER;
BEGIN
    V_FECHA := TO_CHAR(SYSDATE,'YYYYMMDD');
    V_SECUENCIA := TO_NUMBER(V_FECHA || LPAD(FIDE_FACTURAS_TB_SEQ.NEXTVAL,10,0));
    RETURN V_SECUENCIA;
END FACTURAS_TB_SECUENCIA_FN;
-------------------------------------------------------------------------------------------------
FUNCTION PROVEEDORES_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';

    CURSOR C_PROV IS
        SELECT PROVEEDOR_ID,
               NOMBRE,
               CONTACTO
        FROM FIDE_PROVEEDORES_TB
        WHERE ESTADO_ID = 1
        ORDER BY NOMBRE;

    V_X NUMBER := 0;
BEGIN
    V_RESULTADO := 'PROVEEDORES ACTIVOS:' || CHR(10) || CHR(10);

    FOR R IN C_PROV LOOP
        V_X := V_X + 1;
        V_RESULTADO := V_RESULTADO ||
            'Proveedor #' || V_X || CHR(10) ||
            'ID: ' || R.PROVEEDOR_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE || CHR(10) ||
            'Contacto: ' || NVL(R.CONTACTO,'Sin contacto registrado') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;

    IF V_X = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay proveedores activos.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total proveedores: ' || V_X;
    END IF;

    RETURN TO_CHAR(V_RESULTADO);

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar proveedores: ' || SQLERRM;
END PROVEEDORES_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION USUARIOS_LISTAR_ACTIVOS_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_USUARIOS_ACTIVOS IS
        SELECT USUARIO_ID, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_REGISTRO
        FROM FIDE_USUARIOS_TB
        WHERE ESTADO_ID = 1
        ORDER BY FECHA_REGISTRO DESC;
    V_CONT NUMBER := 0;
BEGIN
    V_RESULTADO := 'USUARIOS ACTIVOS:' || CHR(10) || CHR(10);
    FOR R IN C_USUARIOS_ACTIVOS LOOP
        V_CONT := V_CONT + 1;
        V_RESULTADO := V_RESULTADO ||
            'Usuario #' || V_CONT || CHR(10) ||
            'ID: ' || R.USUARIO_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE || ' ' || R.APELLIDO_PATERNO ||
                NVL(' ' || R.APELLIDO_MATERNO, '') || CHR(10) ||
            'Fecha registro: ' || TO_CHAR(R.FECHA_REGISTRO,'DD/MM/YYYY') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_CONT = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay usuarios activos registrados.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de usuarios activos: ' || V_CONT;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar usuarios activos: ' || SQLERRM;
END USUARIOS_LISTAR_ACTIVOS_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CLIENTES_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_CLIENTES IS
        SELECT cl.CLIENTE_ID, u.NOMBRE, u.APELLIDO_PATERNO, u.APELLIDO_MATERNO
        FROM FIDE_CLIENTES_TB cl
        JOIN FIDE_USUARIOS_TB u ON cl.USUARIO_ID = u.USUARIO_ID
        WHERE cl.ESTADO_ID = 1
        ORDER BY u.NOMBRE;
    V_C NUMBER := 0;
BEGIN
    V_RESULTADO := 'CLIENTES REGISTRADOS:' || CHR(10) || CHR(10);
    FOR R IN C_CLIENTES LOOP
        V_C := V_C + 1;
        V_RESULTADO := V_RESULTADO ||
            'Cliente #' || V_C || CHR(10) ||
            'ID: ' || R.CLIENTE_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE || ' ' || R.APELLIDO_PATERNO ||
                NVL(' ' || R.APELLIDO_MATERNO, '') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_C = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No existen clientes registrados.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de clientes: ' || V_C;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar los clientes: ' || SQLERRM;
END CLIENTES_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION SERVICIOS_LISTAR_ACTIVOS_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_SERVICIOS IS
        SELECT s.SERVICIO_ID, s.NOMBRE, s.PRECIO, c.NOMBRE_CATEGORIA
        FROM FIDE_SERVICIOS_TB s
        JOIN FIDE_CATEGORIAS_TB c ON s.CATEGORIA_ID = c.CATEGORIA_ID
        WHERE s.ESTADO_ID = 1
        ORDER BY s.NOMBRE;
    V_N NUMBER := 0;
BEGIN
    V_RESULTADO := 'SERVICIOS ACTIVOS:' || CHR(10) || CHR(10);
    FOR R IN C_SERVICIOS LOOP
        V_N := V_N + 1;
        V_RESULTADO := V_RESULTADO ||
            'Servicio #' || V_N || CHR(10) ||
            'ID: ' || R.SERVICIO_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE || CHR(10) ||
            'Categoría: ' || R.NOMBRE_CATEGORIA || CHR(10) ||
            'Precio: ' || TO_CHAR(R.PRECIO,'FM999990.00') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_N = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay servicios activos.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de servicios: ' || V_N;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar servicios activos: ' || SQLERRM;
END SERVICIOS_LISTAR_ACTIVOS_FN;
-------------------------------------------------------------------------------------------------
FUNCTION PRODUCTOS_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_PRODUCTOS IS
        SELECT p.PRODUCTO_ID, p.NOMBRE, pr.NOMBRE AS PROVEEDOR, p.PRECIO
        FROM FIDE_PRODUCTOS_TB p
        JOIN FIDE_PROVEEDORES_TB pr ON p.PROVEEDOR_ID = pr.PROVEEDOR_ID
        WHERE p.ESTADO_ID = 1
        ORDER BY p.NOMBRE;
    V_K NUMBER := 0;
BEGIN
    V_RESULTADO := 'PRODUCTOS ACTIVOS:' || CHR(10) || CHR(10);
    FOR R IN C_PRODUCTOS LOOP
        V_K := V_K + 1;
        V_RESULTADO := V_RESULTADO ||
            'Producto #' || V_K || CHR(10) ||
            'ID: ' || R.PRODUCTO_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE || CHR(10) ||
            'Proveedor: ' || R.PROVEEDOR || CHR(10) ||
            'Precio: ' || TO_CHAR(R.PRECIO,'FM999990.00') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_K = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No existen productos activos.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de productos: ' || V_K;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar productos: ' || SQLERRM;
END PRODUCTOS_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION INVENTARIO_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_INV IS
        SELECT p.NOMBRE AS PRODUCTO, i.CANTIDAD, i.FECHA_ACTUALIZACION
        FROM FIDE_INVENTARIO_TB i
        JOIN FIDE_PRODUCTOS_TB p ON i.PRODUCTO_ID = p.PRODUCTO_ID
        WHERE i.ESTADO_ID = 1
        ORDER BY i.FECHA_ACTUALIZACION DESC;
    V_I NUMBER := 0;
BEGIN
    V_RESULTADO := 'INVENTARIO ACTUAL:' || CHR(10) || CHR(10);
    FOR R IN C_INV LOOP
        V_I := V_I + 1;
        V_RESULTADO := V_RESULTADO ||
            'Producto #' || V_I || CHR(10) ||
            'Nombre: ' || R.PRODUCTO || CHR(10) ||
            'Cantidad: ' || R.CANTIDAD || CHR(10) ||
            'Actualizado: ' || TO_CHAR(R.FECHA_ACTUALIZACION,'DD/MM/YYYY') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_I = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay registros de inventario.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de registros: ' || V_I;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar inventario: ' || SQLERRM;
END INVENTARIO_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION FACTURAS_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_FACT IS
        SELECT f.FACTURA_ID, u.NOMBRE, u.APELLIDO_PATERNO, u.APELLIDO_MATERNO, f.TOTAL, f.FECHA
        FROM FIDE_FACTURAS_TB f
        JOIN FIDE_CLIENTES_TB c ON f.CLIENTE_ID = c.CLIENTE_ID
        JOIN FIDE_USUARIOS_TB u ON c.USUARIO_ID = u.USUARIO_ID
        WHERE f.ESTADO_ID = 1
        ORDER BY f.FECHA DESC;
    V_F NUMBER := 0;
BEGIN
    V_RESULTADO := 'FACTURAS REGISTRADAS:' || CHR(10) || CHR(10);
    FOR R IN C_FACT LOOP
        V_F := V_F + 1;
        V_RESULTADO := V_RESULTADO ||
            'Factura #' || V_F || CHR(10) ||
            'ID: ' || R.FACTURA_ID || CHR(10) ||
            'Cliente: ' || R.NOMBRE || ' ' || R.APELLIDO_PATERNO ||
                NVL(' ' || R.APELLIDO_MATERNO,'') || CHR(10) ||
            'Total: ' || TO_CHAR(R.TOTAL,'FM999990.00') || CHR(10) ||
            'Fecha: ' || TO_CHAR(R.FECHA,'DD/MM/YYYY') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_F = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay facturas registradas.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de facturas: ' || V_F;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar facturas: ' || SQLERRM;
END FACTURAS_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CITAS_LISTAR_TODAS_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_CITAS IS
        SELECT CLIENTE_ID, SERVICIO_ID, FECHA_HORA, ESTADO_ID
        FROM FIDE_CITAS_TB
        ORDER BY FECHA_HORA DESC;
    V_XX NUMBER := 0;
BEGIN
    V_RESULTADO := 'LISTADO GENERAL DE CITAS:' || CHR(10) || CHR(10);
    FOR R IN C_CITAS LOOP
        V_XX := V_XX + 1;
        V_RESULTADO := V_RESULTADO ||
            'Cita #' || V_XX || CHR(10) ||
            'Cliente ID: ' || R.CLIENTE_ID || CHR(10) ||
            'Servicio ID: ' || R.SERVICIO_ID || CHR(10) ||
            'Fecha: ' || TO_CHAR(R.FECHA_HORA,'DD/MM/YYYY HH24:MI') || CHR(10) ||
            'Estado ID: ' || R.ESTADO_ID || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_XX = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No existen citas registradas.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total de citas: ' || V_XX;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar las citas: ' || SQLERRM;
END CITAS_LISTAR_TODAS_FN;
-------------------------------------------------------------------------------------------------
FUNCTION METODOS_PAGO_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_MPAGO IS
        SELECT METODO_PAGO_ID, NOMBRE_METODO
        FROM FIDE_METODOS_PAGO_TB
        WHERE ESTADO_ID = 1
        ORDER BY NOMBRE_METODO;
    V_A NUMBER := 0;
BEGIN
    V_RESULTADO := 'MÉTODOS DE PAGO ACTIVOS:' || CHR(10) || CHR(10);
    FOR R IN C_MPAGO LOOP
        V_A := V_A + 1;
        V_RESULTADO := V_RESULTADO ||
            'Método #' || V_A || CHR(10) ||
            'ID: ' || R.METODO_PAGO_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE_METODO || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_A = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay métodos de pago activos.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total métodos de pago: ' || V_A;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar métodos de pago: ' || SQLERRM;
END METODOS_PAGO_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CATEGORIAS_LISTAR_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_CAT IS
        SELECT CATEGORIA_ID, NOMBRE_CATEGORIA
        FROM FIDE_CATEGORIAS_TB
        WHERE ESTADO_ID = 1
        ORDER BY NOMBRE_CATEGORIA;
    V_CTG NUMBER := 0;
BEGIN
    V_RESULTADO := 'CATEGORÍAS ACTIVAS:' || CHR(10) || CHR(10);
    FOR R IN C_CAT LOOP
        V_CTG := V_CTG + 1;
        V_RESULTADO := V_RESULTADO ||
            'Categoría #' || V_CTG || CHR(10) ||
            'ID: ' || R.CATEGORIA_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE_CATEGORIA || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_CTG = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay categorías activas.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total categorías: ' || V_CTG;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar categorías: ' || SQLERRM;
END CATEGORIAS_LISTAR_FN;
-------------------------------------------------------------------------------------------------
FUNCTION DIRECCIONES_LISTAR_USUARIOS_FN
RETURN VARCHAR2 IS
    V_RESULTADO CLOB := '';
    CURSOR C_DIR IS
        SELECT d.USUARIO_ID, u.NOMBRE, u.APELLIDO_PATERNO, u.APELLIDO_MATERNO,
               dis.NOMBRE_DISTRITO, d.DESCRIPCION
        FROM FIDE_DIRECCIONES_TB d
        JOIN FIDE_USUARIOS_TB u ON d.USUARIO_ID = u.USUARIO_ID
        JOIN FIDE_DISTRITOS_TB dis ON d.DISTRITO_ID = dis.DISTRITO_ID
        WHERE d.ESTADO_ID = 1
        ORDER BY u.NOMBRE;
    V_D NUMBER := 0;
BEGIN
    V_RESULTADO := 'DIRECCIONES DE USUARIOS:' || CHR(10) || CHR(10);
    FOR R IN C_DIR LOOP
        V_D := V_D + 1;
        V_RESULTADO := V_RESULTADO ||
            'Dirección #' || V_D || CHR(10) ||
            'Usuario ID: ' || R.USUARIO_ID || CHR(10) ||
            'Nombre: ' || R.NOMBRE || ' ' || R.APELLIDO_PATERNO ||
                NVL(' ' || R.APELLIDO_MATERNO,'') || CHR(10) ||
            'Distrito: ' || R.NOMBRE_DISTRITO || CHR(10) ||
            'Descripción: ' || NVL(R.DESCRIPCION,'Sin descripción') || CHR(10) ||
            '-----------------------------------------' || CHR(10);
    END LOOP;
    IF V_D = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay direcciones registradas.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) ||
                       'Total direcciones: ' || V_D;
    END IF;
    RETURN TO_CHAR(V_RESULTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al listar direcciones de usuarios: ' || SQLERRM;
END DIRECCIONES_LISTAR_USUARIOS_FN;
-------------------------------------------------------------------------------------------------
FUNCTION SERVICIOS_OBTENER_DETALLE_FN(
    P_SERVICIO_ID NUMBER
) RETURN VARCHAR2 IS
    V_DETALLE VARCHAR2(500);
    CURSOR C_SERVICIO IS
        SELECT NOMBRE, PRECIO, DURACION
        FROM FIDE_SERVICIOS_TB
        WHERE SERVICIO_ID = P_SERVICIO_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR REGISTRO IN C_SERVICIO LOOP
        V_ENCONTRADO := TRUE;
        V_DETALLE :=
              'Servicio: ' || REGISTRO.NOMBRE ||
              ' | Precio: ' || REGISTRO.PRECIO ||
              ' | Duración: ' || REGISTRO.DURACION || ' min';
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe un servicio activo con el ID proporcionado.';
    END IF;
    RETURN V_DETALLE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener los datos del servicio: ' || SQLERRM;
END SERVICIOS_OBTENER_DETALLE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION PRODUCTOS_OBTENER_DETALLE_FN(
    P_PRODUCTO_ID NUMBER
) RETURN VARCHAR2 IS
    V_RESULTADO VARCHAR2(600);
    CURSOR C_PRODUCTO IS
        SELECT p.NOMBRE AS PRODUCTO, p.PRECIO, prov.NOMBRE AS PROVEEDOR
        FROM FIDE_PRODUCTOS_TB p
        JOIN FIDE_PROVEEDORES_TB prov ON p.PROVEEDOR_ID = prov.PROVEEDOR_ID
        WHERE p.PRODUCTO_ID = P_PRODUCTO_ID
          AND p.ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR REGISTRO IN C_PRODUCTO LOOP
        V_ENCONTRADO := TRUE;
        V_RESULTADO :=
              'Producto: ' || REGISTRO.PRODUCTO ||
              ' | Precio: ' || REGISTRO.PRECIO ||
              ' | Proveedor: ' || REGISTRO.PROVEEDOR;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No se encontró el producto solicitado.';
    END IF;
    RETURN V_RESULTADO;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener los datos del producto: ' || SQLERRM;
END PRODUCTOS_OBTENER_DETALLE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION PROVEEDORES_OBTENER_DETALLE_FN(
    P_PROVEEDOR_ID NUMBER
) RETURN VARCHAR2 IS
    V_RESULTADO VARCHAR2(300);
    CURSOR C_PROV IS
        SELECT NOMBRE, CONTACTO
        FROM FIDE_PROVEEDORES_TB
        WHERE PROVEEDOR_ID = P_PROVEEDOR_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_PROV LOOP
        V_ENCONTRADO := TRUE;
        V_RESULTADO := 'Proveedor: ' || R.NOMBRE || ' | Contacto: ' || NVL(R.CONTACTO,'N/A');
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No se encontró el proveedor especificado.';
    END IF;
    RETURN V_RESULTADO;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener los datos del proveedor: ' || SQLERRM;
END PROVEEDORES_OBTENER_DETALLE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CLIENTES_OBTENER_CORREO_FN(
    P_CLIENTE_ID NUMBER
) RETURN VARCHAR2 IS
    V_CORREO VARCHAR2(300);
    CURSOR C_CORREO IS
        SELECT c.CORREO
        FROM FIDE_CLIENTES_TB cl
        JOIN FIDE_USUARIOS_TB u ON cl.USUARIO_ID = u.USUARIO_ID
        JOIN FIDE_CORREOS_TB c ON u.CORREO_ID = c.CORREO_ID
        WHERE cl.CLIENTE_ID = P_CLIENTE_ID
          AND cl.ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_CORREO LOOP
        V_ENCONTRADO := TRUE;
        V_CORREO := R.CORREO;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No se encontró un correo asociado al cliente.';
    END IF;
    RETURN V_CORREO;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el correo del cliente: ' || SQLERRM;
END CLIENTES_OBTENER_CORREO_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CITAS_OBTENER_DETALLE_FN(
    P_CITA_ID NUMBER
) RETURN VARCHAR2 IS
    V_DETALLE VARCHAR2(700);
    CURSOR C_CITA IS
        SELECT ci.FECHA_HORA, NVL(ci.NOTAS,'Sin notas') AS NOTAS,
               u.NOMBRE || ' ' || u.APELLIDO_PATERNO AS CLIENTE,
               s.NOMBRE AS SERVICIO
        FROM FIDE_CITAS_TB ci
        JOIN FIDE_CLIENTES_TB cl ON ci.CLIENTE_ID = cl.CLIENTE_ID
        JOIN FIDE_USUARIOS_TB u ON cl.USUARIO_ID = u.USUARIO_ID
        JOIN FIDE_SERVICIOS_TB s ON ci.SERVICIO_ID = s.SERVICIO_ID
        WHERE ci.CITA_ID = P_CITA_ID;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_CITA LOOP
        V_ENCONTRADO := TRUE;
        V_DETALLE :=
            'Cliente: ' || R.CLIENTE ||
            ' | Servicio: ' || R.SERVICIO ||
            ' | Fecha: ' || TO_CHAR(R.FECHA_HORA,'DD/MM/YYYY HH24:MI') ||
            ' | Notas: ' || R.NOTAS;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe una cita con el ID proporcionado.';
    END IF;
    RETURN V_DETALLE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener la información de la cita: ' || SQLERRM;
END CITAS_OBTENER_DETALLE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION INVENTARIO_OBTENER_CANTIDAD_FN(
    P_PRODUCTO_ID NUMBER
) RETURN VARCHAR2 IS
    V_CANTIDAD NUMBER;
    CURSOR C_INV IS
        SELECT CANTIDAD
        FROM FIDE_INVENTARIO_TB
        WHERE PRODUCTO_ID = P_PRODUCTO_ID
        ORDER BY FECHA_ACTUALIZACION DESC;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_INV LOOP
        V_ENCONTRADO := TRUE;
        V_CANTIDAD := R.CANTIDAD;
        EXIT; -- sólo el más reciente
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe inventario registrado para este producto.';
    END IF;
    RETURN 'Cantidad actual: ' || V_CANTIDAD;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener la cantidad del inventario: ' || SQLERRM;
END INVENTARIO_OBTENER_CANTIDAD_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CATEGORIAS_OBTENER_NOMBRE_FN(
    P_CATEGORIA_ID NUMBER
) RETURN VARCHAR2 IS
    V_NOMBRE VARCHAR2(200);
    CURSOR C_CAT IS
        SELECT NOMBRE_CATEGORIA
        FROM FIDE_CATEGORIAS_TB
        WHERE CATEGORIA_ID = P_CATEGORIA_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_CAT LOOP
        V_ENCONTRADO := TRUE;
        V_NOMBRE := R.NOMBRE_CATEGORIA;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe una categoría activa con el ID proporcionado.';
    END IF;
    RETURN V_NOMBRE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el nombre de la categoría: ' || SQLERRM;
END CATEGORIAS_OBTENER_NOMBRE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CORREOS_OBTENER_CORREO_FN(
    P_CORREO_ID NUMBER
) RETURN VARCHAR2 IS
    V_CORREO VARCHAR2(255);
    CURSOR C_CORR IS
        SELECT CORREO
        FROM FIDE_CORREOS_TB
        WHERE CORREO_ID = P_CORREO_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_CORR LOOP
        V_ENCONTRADO := TRUE;
        V_CORREO := R.CORREO;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe un correo activo con el ID proporcionado.';
    END IF;
    RETURN V_CORREO;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el correo: ' || SQLERRM;
END CORREOS_OBTENER_CORREO_FN;
-------------------------------------------------------------------------------------------------
FUNCTION DIRECCIONES_OBTENER_DETALLE_FN (
    P_USUARIO_ID NUMBER
) RETURN VARCHAR2 IS
    V_DIRECCION VARCHAR2(700);
    CURSOR C_DIR IS
        SELECT p.NOMBRE_PROVINCIA, c.NOMBRE_CANTON, d.NOMBRE_DISTRITO, dr.DESCRIPCION
        FROM FIDE_DIRECCIONES_TB dr
        JOIN FIDE_DISTRITOS_TB d ON dr.DISTRITO_ID = d.DISTRITO_ID
        JOIN FIDE_CANTONES_TB c ON d.CANTON_ID = c.CANTON_ID
        JOIN FIDE_PROVINCIAS_TB p ON c.PROVINCIA_ID = p.PROVINCIA_ID
        WHERE dr.USUARIO_ID = P_USUARIO_ID
          AND dr.ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_DIR LOOP
        V_ENCONTRADO := TRUE;
        V_DIRECCION :=
            R.NOMBRE_PROVINCIA || ', ' ||
            R.NOMBRE_CANTON || ', ' ||
            R.NOMBRE_DISTRITO || ' - ' ||
            NVL(R.DESCRIPCION,'Sin detalle');
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No se encontró una dirección activa asociada al usuario.';
    END IF;
    RETURN V_DIRECCION;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener la dirección del usuario: ' || SQLERRM;
END DIRECCIONES_OBTENER_DETALLE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION TELEFONOS_OBTENER_TELEFONO_FN (
    P_TELEFONO_ID NUMBER
) RETURN VARCHAR2 IS
    V_TEL VARCHAR2(50);
    CURSOR C_TEL IS
        SELECT TELEFONO
        FROM FIDE_TELEFONOS_TB
        WHERE TELEFONO_ID = P_TELEFONO_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_TEL LOOP
        V_ENCONTRADO := TRUE;
        V_TEL := R.TELEFONO;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe un teléfono activo con el ID proporcionado.';
    END IF;
    RETURN V_TEL;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el número telefónico: ' || SQLERRM;
END TELEFONOS_OBTENER_TELEFONO_FN;
-------------------------------------------------------------------------------------------------
FUNCTION ROLES_OBTENER_NOMBRE_FN (
    P_ROL_ID NUMBER
) RETURN VARCHAR2 IS
    V_ROL VARCHAR2(150);
    CURSOR C_ROL IS
        SELECT NOMBRE_ROL
        FROM FIDE_ROLES_TB
        WHERE ROL_ID = P_ROL_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_ROL LOOP
        V_ENCONTRADO := TRUE;
        V_ROL := R.NOMBRE_ROL;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No se encontró un rol activo con el ID especificado.';
    END IF;
    RETURN V_ROL;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el rol: ' || SQLERRM;
END ROLES_OBTENER_NOMBRE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION FACTURAS_OBTENER_DETALLE_FN (
    P_FACTURA_ID NUMBER
) RETURN VARCHAR2 IS
    V_RESULT VARCHAR2(800);
    CURSOR C_FACT IS
        SELECT f.FECHA, f.TOTAL, f.IMPUESTOS,
               u.NOMBRE || ' ' || u.APELLIDO_PATERNO AS CLIENTE
        FROM FIDE_FACTURAS_TB f
        JOIN FIDE_CLIENTES_TB c ON f.CLIENTE_ID = c.CLIENTE_ID
        JOIN FIDE_USUARIOS_TB u ON c.USUARIO_ID = u.USUARIO_ID
        WHERE f.FACTURA_ID = P_FACTURA_ID
          AND f.ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_FACT LOOP
        V_ENCONTRADO := TRUE;
        V_RESULT :=
            'Cliente: ' || R.CLIENTE ||
            ' | Fecha: ' || TO_CHAR(R.FECHA,'DD/MM/YYYY') ||
            ' | Total: ' || R.TOTAL ||
            ' | Impuestos: ' || R.IMPUESTOS;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe una factura activa con el ID especificado.';
    END IF;
    RETURN V_RESULT;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener los datos de la factura: ' || SQLERRM;
END FACTURAS_OBTENER_DETALLE_FN;
-------------------------------------------------------------------------------------------------
FUNCTION USUARIOS_OBTENER_ROL_FN (
    P_USUARIO_ID NUMBER
) RETURN VARCHAR2 IS
    V_ROL VARCHAR2(150);
    CURSOR C_UROL IS
        SELECT r.NOMBRE_ROL
        FROM FIDE_USUARIOS_TB u
        JOIN FIDE_ROLES_TB r ON u.ROL_ID = r.ROL_ID
        WHERE u.USUARIO_ID = P_USUARIO_ID
          AND u.ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_UROL LOOP
        V_ENCONTRADO := TRUE;
        V_ROL := R.NOMBRE_ROL;
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'El usuario no tiene un rol activo asociado o no existe.';
    END IF;
    RETURN V_ROL;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el rol del usuario: ' || SQLERRM;
END USUARIOS_OBTENER_ROL_FN;
-------------------------------------------------------------------------------------------------
FUNCTION CLIENTES_OBTENER_HISTORIAL_FN (
    P_CLIENTE_ID NUMBER
) RETURN VARCHAR2 IS
    V_HIST VARCHAR2(2000);
    CURSOR C_HIST IS
        SELECT HISTORIAL_TRATAMIENTOS
        FROM FIDE_CLIENTES_TB
        WHERE CLIENTE_ID = P_CLIENTE_ID
          AND ESTADO_ID = 1;
    V_ENCONTRADO BOOLEAN := FALSE;
BEGIN
    FOR R IN C_HIST LOOP
        V_ENCONTRADO := TRUE;
        V_HIST := NVL(R.HISTORIAL_TRATAMIENTOS,'Sin historial registrado');
    END LOOP;
    IF NOT V_ENCONTRADO THEN
        RETURN 'No existe un cliente activo con historial registrado.';
    END IF;
    RETURN V_HIST;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener el historial del cliente: ' || SQLERRM;
END CLIENTES_OBTENER_HISTORIAL_FN;
-------------------------------------------------------------------------------------------------
-- =========================
-- PROCEDIMIENTOS
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
END FIDE_ESTADOS_INSERTAR_SP;
-------------------------------------------------------------------------------------------------
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
END FIDE_ESTADOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_ROLES_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_ROLES_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_ROLES_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_CORREOS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_CORREOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_CORREOS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_TELEFONOS_INSERTAR_SP (
  p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE,
  p_estado_id   IN FIDE_TELEFONOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_telefono    IN FIDE_TELEFONOS_TB.TELEFONO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_TELEFONOS_TB (TELEFONO_ID, ESTADO_ID, TELEFONO)
  VALUES (p_telefono_id, p_estado_id, p_telefono);
  DBMS_OUTPUT.PUT_LINE('Tel�fono insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar tel�fono.');
END FIDE_TELEFONOS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  DBMS_OUTPUT.PUT_LINE('Tel�fono modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar tel�fono.');
END FIDE_TELEFONOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_TELEFONOS_ELIMINAR_SP (
  p_telefono_id IN FIDE_TELEFONOS_TB.TELEFONO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_TELEFONOS_TB
     SET ESTADO_ID = 2 -- Inactivo
   WHERE TELEFONO_ID = p_telefono_id;
  DBMS_OUTPUT.PUT_LINE('Tel�fono eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar tel�fono.');
END FIDE_TELEFONOS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_USUARIOS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_USUARIOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_USUARIOS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_CLIENTES_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CLIENTES_MODIFICAR_SP (
  p_cliente_id   IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
  p_usuario_id   IN FIDE_CLIENTES_TB.USUARIO_ID%TYPE,
  p_estado_id    IN FIDE_CLIENTES_TB.ESTADO_ID%TYPE,
  p_preferencias IN FIDE_CLIENTES_TB.PREFERENCIAS%TYPE,
  p_historial    IN FIDE_CLIENTES_TB.HISTORIAL_TRATAMIENTOS%TYPE
) IS
BEGIN
  UPDATE FIDE_CLIENTES_TB
     SET USUARIO_ID             = p_usuario_id,
         ESTADO_ID              = p_estado_id,
         PREFERENCIAS           = p_preferencias,
         HISTORIAL_TRATAMIENTOS = p_historial
   WHERE CLIENTE_ID = p_cliente_id;
  DBMS_OUTPUT.PUT_LINE('Cliente modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar cliente.');
END FIDE_CLIENTES_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_CLIENTES_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_PROVINCIAS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVINCIAS_MODIFICAR_SP (
  p_provincia_id IN FIDE_PROVINCIAS_TB.PROVINCIA_ID%TYPE,
  p_estado_id    IN FIDE_PROVINCIAS_TB.ESTADO_ID%TYPE,
  p_nombre       IN FIDE_PROVINCIAS_TB.NOMBRE_PROVINCIA%TYPE
) IS
BEGIN
  UPDATE FIDE_PROVINCIAS_TB
     SET ESTADO_ID        = p_estado_id,
         NOMBRE_PROVINCIA = p_nombre
   WHERE PROVINCIA_ID = p_provincia_id;
  DBMS_OUTPUT.PUT_LINE('Provincia modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar provincia.');
END FIDE_PROVINCIAS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_PROVINCIAS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CANTONES_INSERTAR_SP (
  p_canton_id    IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
  p_provincia_id IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
  p_estado_id    IN FIDE_CANTONES_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre_canton IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CANTONES_TB
    (CANTON_ID, PROVINCIA_ID, ESTADO_ID, NOMBRE_CANTON)
  VALUES
    (p_canton_id, p_provincia_id, p_estado_id, p_nombre_canton);
  DBMS_OUTPUT.PUT_LINE('Cant�n insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar cant�n.');
END FIDE_CANTONES_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CANTONES_MODIFICAR_SP (
  p_canton_id     IN FIDE_CANTONES_TB.CANTON_ID%TYPE,
  p_provincia_id  IN FIDE_CANTONES_TB.PROVINCIA_ID%TYPE,
  p_estado_id     IN FIDE_CANTONES_TB.ESTADO_ID%TYPE,
  p_nombre_canton IN FIDE_CANTONES_TB.NOMBRE_CANTON%TYPE
) IS
BEGIN
  UPDATE FIDE_CANTONES_TB
     SET PROVINCIA_ID  = p_provincia_id,
         ESTADO_ID     = p_estado_id,
         NOMBRE_CANTON = p_nombre_canton
   WHERE CANTON_ID = p_canton_id;
  DBMS_OUTPUT.PUT_LINE('Cant�n modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar cant�n.');
END FIDE_CANTONES_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CANTONES_ELIMINAR_SP (
  p_canton_id IN FIDE_CANTONES_TB.CANTON_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CANTONES_TB
     SET ESTADO_ID = 2
   WHERE CANTON_ID = p_canton_id;
  DBMS_OUTPUT.PUT_LINE('Cant�n eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar cant�n.');
END FIDE_CANTONES_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DISTRITOS_INSERTAR_SP (
  p_distrito_id    IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
  p_canton_id      IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
  p_estado_id      IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre_distrito IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
) IS
BEGIN
  INSERT INTO FIDE_DISTRITOS_TB
    (DISTRITO_ID, CANTON_ID, ESTADO_ID, NOMBRE_DISTRITO)
  VALUES
    (p_distrito_id, p_canton_id, p_estado_id, p_nombre_distrito);
  DBMS_OUTPUT.PUT_LINE('Distrito insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar distrito.');
END FIDE_DISTRITOS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DISTRITOS_MODIFICAR_SP (
  p_distrito_id     IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE,
  p_canton_id       IN FIDE_DISTRITOS_TB.CANTON_ID%TYPE,
  p_estado_id       IN FIDE_DISTRITOS_TB.ESTADO_ID%TYPE,
  p_nombre_distrito IN FIDE_DISTRITOS_TB.NOMBRE_DISTRITO%TYPE
) IS
BEGIN
  UPDATE FIDE_DISTRITOS_TB
     SET CANTON_ID       = p_canton_id,
         ESTADO_ID       = p_estado_id,
         NOMBRE_DISTRITO = p_nombre_distrito
   WHERE DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Distrito modificado.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al modificar distrito.');
END FIDE_DISTRITOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DISTRITOS_ELIMINAR_SP (
  p_distrito_id IN FIDE_DISTRITOS_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_DISTRITOS_TB
     SET ESTADO_ID = 2
   WHERE DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Distrito eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar distrito.');
END FIDE_DISTRITOS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  DBMS_OUTPUT.PUT_LINE('Direcci�n insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar direcci�n.');
END FIDE_DIRECCIONES_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  DBMS_OUTPUT.PUT_LINE('Direcci�n modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar direcci�n.');
END FIDE_DIRECCIONES_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DIRECCIONES_ELIMINAR_SP (
  p_usuario_id  IN FIDE_DIRECCIONES_TB.USUARIO_ID%TYPE,
  p_distrito_id IN FIDE_DIRECCIONES_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_DIRECCIONES_TB
     SET ESTADO_ID = 2
   WHERE USUARIO_ID  = p_usuario_id
     AND DISTRITO_ID = p_distrito_id;
  DBMS_OUTPUT.PUT_LINE('Direcci�n eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar direcci�n.');
END FIDE_DIRECCIONES_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_INSERTAR_SP (
  p_categoria_id   IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
  p_estado_id      IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_nombre_categoria IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
) IS
BEGIN
  INSERT INTO FIDE_CATEGORIAS_TB
    (CATEGORIA_ID, ESTADO_ID, NOMBRE_CATEGORIA)
  VALUES
    (p_categoria_id, p_estado_id, p_nombre_categoria);
  DBMS_OUTPUT.PUT_LINE('Categor�a insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar categor�a.');
END FIDE_CATEGORIAS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_MODIFICAR_SP (
  p_categoria_id    IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
  p_estado_id       IN FIDE_CATEGORIAS_TB.ESTADO_ID%TYPE,
  p_nombre_categoria IN FIDE_CATEGORIAS_TB.NOMBRE_CATEGORIA%TYPE
) IS
BEGIN
  UPDATE FIDE_CATEGORIAS_TB
     SET ESTADO_ID        = p_estado_id,
         NOMBRE_CATEGORIA = p_nombre_categoria
   WHERE CATEGORIA_ID = p_categoria_id;
  DBMS_OUTPUT.PUT_LINE('Categor�a modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar categor�a.');
END FIDE_CATEGORIAS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_ELIMINAR_SP (
  p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CATEGORIAS_TB
     SET ESTADO_ID = 2
   WHERE CATEGORIA_ID = p_categoria_id;
  DBMS_OUTPUT.PUT_LINE('Categor�a eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar categor�a.');
END FIDE_CATEGORIAS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE  FIDE_SERVICIOS_INSERTAR_SP (
  p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
  p_estado_id   IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_categoria_id IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
  p_nombre      IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
  p_descripcion IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
  p_duracion    IN FIDE_SERVICIOS_TB.DURACION%TYPE,
  p_precio      IN FIDE_SERVICIOS_TB.PRECIO%TYPE,
  p_imagen_url  IN FIDE_SERVICIOS_TB.IMAGEN_URL%TYPE
) IS
BEGIN
  INSERT INTO FIDE_SERVICIOS_TB
    (SERVICIO_ID, ESTADO_ID, CATEGORIA_ID, NOMBRE, DESCRIPCION, DURACION, PRECIO, IMAGEN_URL)
  VALUES
    (p_servicio_id, p_estado_id, p_categoria_id, p_nombre, p_descripcion, p_duracion, p_precio, p_imagen_url);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar servicio.');
END FIDE_SERVICIOS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_MODIFICAR_SP (
  p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
  p_estado_id   IN FIDE_SERVICIOS_TB.ESTADO_ID%TYPE,
  p_categoria_id IN FIDE_SERVICIOS_TB.CATEGORIA_ID%TYPE,
  p_nombre      IN FIDE_SERVICIOS_TB.NOMBRE%TYPE,
  p_descripcion IN FIDE_SERVICIOS_TB.DESCRIPCION%TYPE,
  p_duracion    IN FIDE_SERVICIOS_TB.DURACION%TYPE,
  p_precio      IN FIDE_SERVICIOS_TB.PRECIO%TYPE,
  p_imagen_url  IN FIDE_SERVICIOS_TB.IMAGEN_URL%TYPE
) IS
BEGIN
  UPDATE FIDE_SERVICIOS_TB
     SET ESTADO_ID   = p_estado_id,
         CATEGORIA_ID = p_categoria_id,
         NOMBRE       = p_nombre,
         DESCRIPCION  = p_descripcion,
         DURACION     = p_duracion,
         PRECIO       = p_precio,
         IMAGEN_URL   = p_imagen_url
   WHERE SERVICIO_ID = p_servicio_id;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar servicio.');
END FIDE_SERVICIOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_ELIMINAR_SP (
  p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_SERVICIOS_TB
     SET ESTADO_ID = 2
   WHERE SERVICIO_ID = p_servicio_id;
  DBMS_OUTPUT.PUT_LINE('Servicio eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar servicio.');
END FIDE_SERVICIOS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CITAS_INSERTAR_SP (
  p_cliente_id IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
  p_servicio_id IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
  p_estado_id  IN FIDE_CITAS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_fecha_hora IN TIMESTAMP,
  p_notas      IN FIDE_CITAS_TB.NOTAS%TYPE
) IS
  v_count_global NUMBER;
  v_count_cliente NUMBER;
BEGIN
  -- VALIDACI�N A: evitar doble cita global en esa hora
  SELECT COUNT(*)
  INTO v_count_global
  FROM FIDE_CITAS_TB
  WHERE FECHA_HORA = p_fecha_hora
    AND ESTADO_ID = 1;

  IF v_count_global > 0 THEN
    RAISE_APPLICATION_ERROR(
      -20002,
      'Este horario ya est� ocupado. Seleccione otra hora.'
    );
  END IF;

  -- VALIDACI�N B: evitar doble cita del MISMO cliente
  SELECT COUNT(*)
  INTO v_count_cliente
  FROM FIDE_CITAS_TB
  WHERE FECHA_HORA = p_fecha_hora
    AND CLIENTE_ID = p_cliente_id
    AND ESTADO_ID = 1;

  IF v_count_cliente > 0 THEN
    RAISE_APPLICATION_ERROR(
      -20003,
      'No puedes agendar este servicio porque ya tienes uno a esa hora.'
    );
  END IF;

  -- Inserci�n v�lida
  INSERT INTO FIDE_CITAS_TB
    (CITA_ID, CLIENTE_ID, SERVICIO_ID, ESTADO_ID, FECHA_HORA, NOTAS)
  VALUES
    (SEQ_CITAS.NEXTVAL, p_cliente_id, p_servicio_id, p_estado_id, p_fecha_hora, p_notas);

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error al insertar cita: ' || SQLERRM);
END FIDE_CITAS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 PROCEDURE FIDE_CITAS_MODIFICAR_SP (
  p_cita_id    IN FIDE_CITAS_TB.CITA_ID%TYPE,
  p_cliente_id IN FIDE_CITAS_TB.CLIENTE_ID%TYPE,
  p_servicio_id IN FIDE_CITAS_TB.SERVICIO_ID%TYPE,
  p_estado_id  IN FIDE_CITAS_TB.ESTADO_ID%TYPE,
  p_fecha_hora IN FIDE_CITAS_TB.FECHA_HORA%TYPE,
  p_notas      IN FIDE_CITAS_TB.NOTAS%TYPE
) IS
BEGIN
  UPDATE FIDE_CITAS_TB
     SET CLIENTE_ID = p_cliente_id,
         SERVICIO_ID = p_servicio_id,
         ESTADO_ID  = p_estado_id,
         FECHA_HORA = p_fecha_hora,
         NOTAS      = p_notas
   WHERE CITA_ID = p_cita_id;
  DBMS_OUTPUT.PUT_LINE('Cita modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar cita.');
END FIDE_CITAS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CITAS_ELIMINAR_SP (
  p_cita_id IN FIDE_CITAS_TB.CITA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_CITAS_TB
     SET ESTADO_ID = 2
   WHERE CITA_ID = p_cita_id;
  DBMS_OUTPUT.PUT_LINE('Cita eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar cita.');
END FIDE_CITAS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_PROVEEDORES_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_PROVEEDORES_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVEEDORES_ELIMINAR_SP (
  p_proveedor_id IN FIDE_PROVEEDORES_TB.PROVEEDOR_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_PROVEEDORES_TB
     SET ESTADO_ID = 2
   WHERE PROVEEDOR_ID = p_proveedor_id;
  DBMS_OUTPUT.PUT_LINE('Proveedor eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar proveedor.');
END FIDE_PROVEEDORES_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_INSERTAR_SP (
  p_producto_id  IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
  p_categoria_id IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
  p_estado_id    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_proveedor_id IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
  p_nombre       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
  p_descripcion  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
  p_precio       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE,
  p_imagen_url   IN FIDE_PRODUCTOS_TB.IMAGEN_URL%TYPE
) IS
BEGIN
  INSERT INTO FIDE_PRODUCTOS_TB
    (PRODUCTO_ID, CATEGORIA_ID, ESTADO_ID, PROVEEDOR_ID, NOMBRE, DESCRIPCION, PRECIO, IMAGEN_URL)
  VALUES
    (p_producto_id, p_categoria_id, p_estado_id, p_proveedor_id,
     p_nombre, p_descripcion, p_precio, p_imagen_url);

  DBMS_OUTPUT.PUT_LINE('Producto insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar producto.');
END FIDE_PRODUCTOS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_MODIFICAR_SP (
  p_producto_id  IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
  p_categoria_id IN FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
  p_estado_id    IN FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE,
  p_proveedor_id IN FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
  p_nombre       IN FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
  p_descripcion  IN FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
  p_precio       IN FIDE_PRODUCTOS_TB.PRECIO%TYPE,
  p_imagen_url   IN FIDE_PRODUCTOS_TB.IMAGEN_URL%TYPE
) IS
BEGIN
  UPDATE FIDE_PRODUCTOS_TB
     SET CATEGORIA_ID = p_categoria_id,
         ESTADO_ID    = p_estado_id,
         PROVEEDOR_ID = p_proveedor_id,
         NOMBRE       = p_nombre,
         DESCRIPCION  = p_descripcion,
         PRECIO       = p_precio,
         IMAGEN_URL   = p_imagen_url
   WHERE PRODUCTO_ID = p_producto_id;

  DBMS_OUTPUT.PUT_LINE('Producto modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar producto.');
END FIDE_PRODUCTOS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_ELIMINAR_SP (
  p_producto_id IN FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_PRODUCTOS_TB
     SET ESTADO_ID = 2
   WHERE PRODUCTO_ID = p_producto_id;
  DBMS_OUTPUT.PUT_LINE('Producto eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar producto.');
END FIDE_PRODUCTOS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_INSERTAR_SP (
  p_producto_id        IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
  p_estado_id          IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_cantidad           IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE,
  p_fecha_actualizacion IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE DEFAULT SYSDATE
) IS
BEGIN
  INSERT INTO FIDE_INVENTARIO_TB
    (PRODUCTO_ID, ESTADO_ID, CANTIDAD, FECHA_ACTUALIZACION)
  VALUES
    (p_producto_id, p_estado_id, p_cantidad, p_fecha_actualizacion);
  DBMS_OUTPUT.PUT_LINE('Inventario insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar inventario.');
END FIDE_INVENTARIO_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_MODIFICAR_SP (
  p_producto_id        IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
  p_fecha_actualizacion IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE,
  p_estado_id          IN FIDE_INVENTARIO_TB.ESTADO_ID%TYPE,
  p_cantidad           IN FIDE_INVENTARIO_TB.CANTIDAD%TYPE
) IS
BEGIN
  UPDATE FIDE_INVENTARIO_TB
     SET ESTADO_ID          = p_estado_id,
         CANTIDAD           = p_cantidad
   WHERE PRODUCTO_ID        = p_producto_id
     AND FECHA_ACTUALIZACION = p_fecha_actualizacion;
  DBMS_OUTPUT.PUT_LINE('Inventario modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar inventario.');
END FIDE_INVENTARIO_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_ELIMINAR_SP (
  p_producto_id        IN FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
  p_fecha_actualizacion IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE
) IS
BEGIN
  UPDATE FIDE_INVENTARIO_TB
     SET ESTADO_ID = 2
   WHERE PRODUCTO_ID        = p_producto_id
     AND FECHA_ACTUALIZACION = p_fecha_actualizacion;
  DBMS_OUTPUT.PUT_LINE('Inventario eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar inventario.');
END FIDE_INVENTARIO_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  DBMS_OUTPUT.PUT_LINE('M�todo de pago insertado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar m�todo de pago.');
END FIDE_METODOS_PAGO_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  DBMS_OUTPUT.PUT_LINE('M�todo de pago modificado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar m�todo de pago.');
END FIDE_METODOS_PAGO_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_METODOS_PAGO_ELIMINAR_SP (
  p_metodo_pago_id IN FIDE_METODOS_PAGO_TB.METODO_PAGO_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_METODOS_PAGO_TB
     SET ESTADO_ID = 2
   WHERE METODO_PAGO_ID = p_metodo_pago_id;
  DBMS_OUTPUT.PUT_LINE('M�todo de pago eliminado.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar m�todo de pago.');
END FIDE_METODOS_PAGO_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_FACTURAS_INSERTAR_SP (
  p_factura_id     IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
  p_cliente_id     IN FIDE_FACTURAS_TB.CLIENTE_ID%TYPE,
  p_estado_id      IN FIDE_FACTURAS_TB.ESTADO_ID%TYPE DEFAULT 1,
  p_metodo_pago_id IN FIDE_FACTURAS_TB.METODO_PAGO_ID%TYPE,
  p_fecha          IN FIDE_FACTURAS_TB.FECHA%TYPE,
  p_impuestos      IN FIDE_FACTURAS_TB.IMPUESTOS%TYPE,
  p_total          IN FIDE_FACTURAS_TB.TOTAL%TYPE
) IS
BEGIN
  INSERT INTO FIDE_FACTURAS_TB
    (FACTURA_ID, CLIENTE_ID, ESTADO_ID, METODO_PAGO_ID, FECHA, IMPUESTOS, TOTAL)
  VALUES
    (p_factura_id, p_cliente_id, p_estado_id, p_metodo_pago_id,
     p_fecha, p_impuestos, p_total);
  DBMS_OUTPUT.PUT_LINE('Factura insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar factura.');
END FIDE_FACTURAS_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
END FIDE_FACTURAS_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_FACTURAS_ELIMINAR_SP (
  p_factura_id IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE
) IS
BEGIN
  UPDATE FIDE_FACTURAS_TB
     SET ESTADO_ID = 2
   WHERE FACTURA_ID = p_factura_id;
  DBMS_OUTPUT.PUT_LINE('Factura eliminada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al eliminar factura.');
END FIDE_FACTURAS_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 PROCEDURE FIDE_DETALLES_FACTURA_INSERTAR_SP (
  p_factura_id      IN NUMBER,
  p_producto_id     IN NUMBER,
  p_precio_unitario IN NUMBER,
  p_cantidad        IN NUMBER,
  p_estado_id       IN NUMBER DEFAULT 1
)
IS
BEGIN
  INSERT INTO FIDE_DETALLES_FACTURA_TB (
      FACTURA_ID,
      PRODUCTO_ID,
      PRECIO_UNITARIO,
      CANTIDAD,
      ESTADO_ID
  )
  VALUES (
      p_factura_id,
      p_producto_id,
      p_precio_unitario,
      p_cantidad,
      p_estado_id
  );

  DBMS_OUTPUT.PUT_LINE('Detalle de factura insertado.');
END FIDE_DETALLES_FACTURA_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DETALLES_FACTURA_MODIFICAR_SP (
  p_factura_id      IN NUMBER,
  p_producto_id     IN NUMBER,
  p_precio_unitario IN NUMBER,
  p_cantidad        IN NUMBER,
  p_estado_id       IN NUMBER
)
IS
BEGIN
  UPDATE FIDE_DETALLES_FACTURA_TB
     SET PRECIO_UNITARIO = p_precio_unitario,
         CANTIDAD        = p_cantidad,
         ESTADO_ID       = p_estado_id
   WHERE FACTURA_ID  = p_factura_id
     AND PRODUCTO_ID = p_producto_id;

  DBMS_OUTPUT.PUT_LINE('Detalle de factura modificado.');
END FIDE_DETALLES_FACTURA_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DETALLES_FACTURA_ELIMINAR_SP (
  p_factura_id  IN NUMBER,
  p_producto_id IN NUMBER
)
IS
BEGIN
  UPDATE FIDE_DETALLES_FACTURA_TB
     SET ESTADO_ID = 2
   WHERE FACTURA_ID  = p_factura_id
     AND PRODUCTO_ID = p_producto_id;

  DBMS_OUTPUT.PUT_LINE('Detalle de factura eliminado (estado=2).');
END FIDE_DETALLES_FACTURA_ELIMINAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_DIRECCIONES_PROVEEDORES_INSERTAR_SP (
  p_proveedor_id IN FIDE_DIRECCIONES_PROVEEDORES_TB.PROVEEDOR_ID%TYPE,
  p_distrito_id  IN FIDE_DIRECCIONES_PROVEEDORES_TB.DISTRITO_ID%TYPE
) IS
BEGIN
  INSERT INTO FIDE_DIRECCIONES_PROVEEDORES_TB (PROVEEDOR_ID, DISTRITO_ID)
  VALUES (p_proveedor_id, p_distrito_id);
  DBMS_OUTPUT.PUT_LINE('Direcci�n de proveedor insertada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar direcci�n de proveedor.');
END FIDE_DIRECCIONES_PROVEEDORES_INSERTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  DBMS_OUTPUT.PUT_LINE('Direcci�n de proveedor modificada.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al modificar direcci�n de proveedor.');
END FIDE_DIRECCIONES_PROVEEDORES_MODIFICAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CLIENTES_LISTAR_SP (
  p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
      CLIENTE_ID,
      USUARIO_ID,
      ESTADO_ID,
      PREFERENCIAS,
      HISTORIAL_TRATAMIENTOS
    FROM FIDE_CLIENTES_TB
    ORDER BY CLIENTE_ID;

  DBMS_OUTPUT.PUT_LINE('Listado de clientes obtenido correctamente.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al listar clientes: ' || SQLERRM);
    OPEN p_cursor FOR 
      SELECT 
        NULL AS CLIENTE_ID,
        NULL AS USUARIO_ID,
        NULL AS ESTADO_ID,
        NULL AS PREFERENCIAS,
        NULL AS HISTORIAL_TRATAMIENTOS
      FROM dual
      WHERE 1 = 0;
END FIDE_CLIENTES_LISTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CLIENTES_OBTENER_SP (
  p_cliente_id IN FIDE_CLIENTES_TB.CLIENTE_ID%TYPE,
  p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
      CLIENTE_ID,
      USUARIO_ID,
      ESTADO_ID,
      PREFERENCIAS,
      HISTORIAL_TRATAMIENTOS
    FROM FIDE_CLIENTES_TB
    WHERE CLIENTE_ID = p_cliente_id;

  DBMS_OUTPUT.PUT_LINE('Detalle del cliente obtenido.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al obtener cliente: ' || SQLERRM);
    OPEN p_cursor FOR 
      SELECT 
        NULL AS CLIENTE_ID,
        NULL AS USUARIO_ID,
        NULL AS ESTADO_ID,
        NULL AS PREFERENCIAS,
        NULL AS HISTORIAL_TRATAMIENTOS
      FROM dual
      WHERE 1 = 0;
END FIDE_CLIENTES_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_LISTAR_SP (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            PRODUCTO_ID,
            CATEGORIA_ID,
            ESTADO_ID,
            PROVEEDOR_ID,
            NOMBRE,
            DESCRIPCION,
            PRECIO,
            IMAGEN_URL
        FROM FIDE_PRODUCTOS_TB
        WHERE ESTADO_ID = 1        -- ? FILTRO CLAVE
        ORDER BY NOMBRE;

EXCEPTION
    WHEN OTHERS THEN

        OPEN p_cursor FOR 
            SELECT 
                NULL AS PRODUCTO_ID,
                NULL AS CATEGORIA_ID,
                NULL AS ESTADO_ID,
                NULL AS PROVEEDOR_ID,
                NULL AS NOMBRE,
                NULL AS DESCRIPCION,
                NULL AS PRECIO,
                NULL AS IMAGEN_URL
            FROM dual
            WHERE 1 = 0;
END FIDE_PRODUCTOS_LISTAR_SP;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PRODUCTOS_OBTENER_SP (
  p_producto_id   IN  FIDE_PRODUCTOS_TB.PRODUCTO_ID%TYPE,
  p_categoria_id  OUT FIDE_PRODUCTOS_TB.CATEGORIA_ID%TYPE,
  p_estado_id     OUT FIDE_PRODUCTOS_TB.ESTADO_ID%TYPE,
  p_proveedor_id  OUT FIDE_PRODUCTOS_TB.PROVEEDOR_ID%TYPE,
  p_nombre        OUT FIDE_PRODUCTOS_TB.NOMBRE%TYPE,
  p_descripcion   OUT FIDE_PRODUCTOS_TB.DESCRIPCION%TYPE,
  p_precio        OUT FIDE_PRODUCTOS_TB.PRECIO%TYPE,
  p_imagen_url    OUT FIDE_PRODUCTOS_TB.IMAGEN_URL%TYPE
)
IS
BEGIN
  SELECT 
      CATEGORIA_ID,
      ESTADO_ID,
      PROVEEDOR_ID,
      NOMBRE,
      DESCRIPCION,
      PRECIO,
      IMAGEN_URL
  INTO
      p_categoria_id,
      p_estado_id,
      p_proveedor_id,
      p_nombre,
      p_descripcion,
      p_precio,
      p_imagen_url
  FROM FIDE_PRODUCTOS_TB
  WHERE PRODUCTO_ID = p_producto_id;

  DBMS_OUTPUT.PUT_LINE('Producto obtenido correctamente.');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Producto no encontrado: ID=' || p_producto_id);

    p_categoria_id := NULL;
    p_estado_id    := NULL;
    p_proveedor_id := NULL;
    p_nombre       := NULL;
    p_descripcion  := NULL;
    p_precio       := NULL;
    p_imagen_url   := NULL;

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al obtener producto: ' || SQLERRM);

    p_categoria_id := NULL;
    p_estado_id    := NULL;
    p_proveedor_id := NULL;
    p_nombre       := NULL;
    p_descripcion  := NULL;
    p_precio       := NULL;
    p_imagen_url   := NULL;
END FIDE_PRODUCTOS_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_OBTENER_POR_ID_SP (
  p_servicio_id IN FIDE_SERVICIOS_TB.SERVICIO_ID%TYPE,
  p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
  SERVICIO_ID,
  ESTADO_ID,
  CATEGORIA_ID,
  NOMBRE,
  DESCRIPCION,
  DURACION,
  PRECIO,
  IMAGEN_URL
FROM FIDE_SERVICIOS_TB
    WHERE SERVICIO_ID = p_servicio_id;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END FIDE_SERVICIOS_OBTENER_POR_ID_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_SERVICIOS_OBTENER_TODOS_SP (
  p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN p_cursor FOR
   SELECT 
  SERVICIO_ID,
  ESTADO_ID,
  CATEGORIA_ID,
  NOMBRE,
  DESCRIPCION,
  DURACION,
  PRECIO,
  IMAGEN_URL
FROM FIDE_SERVICIOS_TB
    WHERE ESTADO_ID = 1
    ORDER BY SERVICIO_ID;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END FIDE_SERVICIOS_OBTENER_TODOS_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_LISTAR_SP (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            PRODUCTO_ID,
            ESTADO_ID,
            CANTIDAD,
            FECHA_ACTUALIZACION
        FROM FIDE_INVENTARIO_TB
        ORDER BY FECHA_ACTUALIZACION DESC;

    DBMS_OUTPUT.PUT_LINE('Listado de inventario obtenido correctamente.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar inventario: ' || SQLERRM);

        OPEN p_cursor FOR
            SELECT
                NULL PRODUCTO_ID,
                NULL ESTADO_ID,
                NULL CANTIDAD,
                NULL FECHA_ACTUALIZACION
            FROM dual WHERE 1=0;
END FIDE_INVENTARIO_LISTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_INVENTARIO_OBTENER_SP (
    p_producto_id        IN  FIDE_INVENTARIO_TB.PRODUCTO_ID%TYPE,
    p_fecha_actualizacion IN FIDE_INVENTARIO_TB.FECHA_ACTUALIZACION%TYPE,
    p_estado_id          OUT FIDE_INVENTARIO_TB.ESTADO_ID%TYPE,
    p_cantidad           OUT FIDE_INVENTARIO_TB.CANTIDAD%TYPE
)
IS
BEGIN
    SELECT
        ESTADO_ID,
        CANTIDAD
    INTO
        p_estado_id,
        p_cantidad
    FROM FIDE_INVENTARIO_TB
    WHERE PRODUCTO_ID = p_producto_id
      AND FECHA_ACTUALIZACION = p_fecha_actualizacion;

    DBMS_OUTPUT.PUT_LINE('Inventario obtenido correctamente.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'Inventario no encontrado: PRODUCTO_ID=' || p_producto_id ||
            ', FECHA=' || p_fecha_actualizacion
        );

        p_estado_id := NULL;
        p_cantidad  := NULL;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al obtener inventario: ' || SQLERRM);

        p_estado_id := NULL;
        p_cantidad  := NULL;
END FIDE_INVENTARIO_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVEEDORES_LISTAR_SP (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            PROVEEDOR_ID,
            ESTADO_ID,
            TELEFONO_ID,
            NOMBRE,
            CONTACTO
        FROM FIDE_PROVEEDORES_TB
        ORDER BY NOMBRE;

    DBMS_OUTPUT.PUT_LINE('Listado de proveedores obtenido correctamente.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar proveedores: ' || SQLERRM);

        OPEN p_cursor FOR
            SELECT
                NULL PROVEEDOR_ID,
                NULL ESTADO_ID,
                NULL TELEFONO_ID,
                NULL NOMBRE,
                NULL CONTACTO
            FROM dual WHERE 1=0;
END FIDE_PROVEEDORES_LISTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_PROVEEDORES_OBTENER_SP (
    p_proveedor_id IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            PROVEEDOR_ID,
            ESTADO_ID,
            TELEFONO_ID,
            NOMBRE,
            CONTACTO
        FROM FIDE_PROVEEDORES_TB
        WHERE PROVEEDOR_ID = p_proveedor_id;
END FIDE_PROVEEDORES_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_USUARIOS_LISTAR_SP (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            USUARIO_ID,
            ROL_ID,
            CORREO_ID,
            TELEFONO_ID,
            ESTADO_ID,
            NOMBRE,
            APELLIDO_PATERNO,
            APELLIDO_MATERNO,
            FECHA_REGISTRO
        FROM FIDE_USUARIOS_TB
        ORDER BY NOMBRE;

    DBMS_OUTPUT.PUT_LINE('Listado de usuarios obtenido correctamente.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar usuarios: ' || SQLERRM);

        OPEN p_cursor FOR
            SELECT
                NULL USUARIO_ID,
                NULL ROL_ID,
                NULL CORREO_ID,
                NULL TELEFONO_ID,
                NULL ESTADO_ID,
                NULL NOMBRE,
                NULL APELLIDO_PATERNO,
                NULL APELLIDO_MATERNO,
                NULL FECHA_REGISTRO
            FROM dual WHERE 1=0;
END FIDE_USUARIOS_LISTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_USUARIOS_OBTENER_SP (
    p_usuario_id        IN  FIDE_USUARIOS_TB.USUARIO_ID%TYPE,
    p_rol_id            OUT FIDE_USUARIOS_TB.ROL_ID%TYPE,
    p_correo_id         OUT FIDE_USUARIOS_TB.CORREO_ID%TYPE,
    p_telefono_id       OUT FIDE_USUARIOS_TB.TELEFONO_ID%TYPE,
    p_estado_id         OUT FIDE_USUARIOS_TB.ESTADO_ID%TYPE,
    p_nombre            OUT FIDE_USUARIOS_TB.NOMBRE%TYPE,
    p_apellido_paterno  OUT FIDE_USUARIOS_TB.APELLIDO_PATERNO%TYPE,
    p_apellido_materno  OUT FIDE_USUARIOS_TB.APELLIDO_MATERNO%TYPE,
    p_fecha_registro    OUT FIDE_USUARIOS_TB.FECHA_REGISTRO%TYPE
)
IS
BEGIN
    SELECT
        ROL_ID,
        CORREO_ID,
        TELEFONO_ID,
        ESTADO_ID,
        NOMBRE,
        APELLIDO_PATERNO,
        APELLIDO_MATERNO,
        FECHA_REGISTRO
    INTO
        p_rol_id,
        p_correo_id,
        p_telefono_id,
        p_estado_id,
        p_nombre,
        p_apellido_paterno,
        p_apellido_materno,
        p_fecha_registro
    FROM FIDE_USUARIOS_TB
    WHERE USUARIO_ID = p_usuario_id;

    DBMS_OUTPUT.PUT_LINE('Usuario obtenido correctamente.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Usuario no encontrado: ID=' || p_usuario_id);

        p_rol_id           := NULL;
        p_correo_id        := NULL;
        p_telefono_id      := NULL;
        p_estado_id        := NULL;
        p_nombre           := NULL;
        p_apellido_paterno := NULL;
        p_apellido_materno := NULL;
        p_fecha_registro   := NULL;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al obtener usuario: ' || SQLERRM);

        p_rol_id           := NULL;
        p_correo_id        := NULL;
        p_telefono_id      := NULL;
        p_estado_id        := NULL;
        p_nombre           := NULL;
        p_apellido_paterno := NULL;
        p_apellido_materno := NULL;
        p_fecha_registro   := NULL;
END FIDE_USUARIOS_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CITAS_LISTAR_SP (
  p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
      c.CITA_ID,
      c.CLIENTE_ID,
      c.SERVICIO_ID,
      s.NOMBRE AS SERVICIO_NOMBRE,
      c.ESTADO_ID,
      e.NOMBRE_ESTADO,
      c.FECHA_HORA,
      c.NOTAS
    FROM FIDE_CITAS_TB c
    JOIN FIDE_SERVICIOS_TB s ON c.SERVICIO_ID = s.SERVICIO_ID
    JOIN FIDE_ESTADOS_TB e ON c.ESTADO_ID = e.ESTADO_ID
    ORDER BY c.FECHA_HORA;

EXCEPTION
  WHEN OTHERS THEN
    OPEN p_cursor FOR SELECT NULL FROM dual WHERE 1 = 0;
END FIDE_CITAS_LISTAR_SP;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CITAS_OBTENER_SP (
  p_cita_id IN FIDE_CITAS_TB.CITA_ID%TYPE,
  p_cursor  OUT SYS_REFCURSOR
) IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
      CITA_ID,
      CLIENTE_ID,
      SERVICIO_ID,
      ESTADO_ID,
      FECHA_HORA,
      NOTAS
    FROM FIDE_CITAS_TB
    WHERE CITA_ID = p_cita_id;

  DBMS_OUTPUT.PUT_LINE('Detalle de la cita obtenido.');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontr� la cita con ID: ' || p_cita_id);
    OPEN p_cursor FOR
      SELECT 
        NULL AS CITA_ID,
        NULL AS CLIENTE_ID,
        NULL AS SERVICIO_ID,
        NULL AS ESTADO_ID,
        NULL AS FECHA_HORA,
        NULL AS NOTAS
      FROM dual WHERE 1 = 0;

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al obtener cita: ' || SQLERRM);
    OPEN p_cursor FOR
      SELECT 
        NULL AS CITA_ID,
        NULL AS CLIENTE_ID,
        NULL AS SERVICIO_ID,
        NULL AS ESTADO_ID,
        NULL AS FECHA_HORA,
        NULL AS NOTAS
      FROM dual WHERE 1 = 0;
END FIDE_CITAS_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_LISTAR_SP (
  p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
      CATEGORIA_ID,
      ESTADO_ID,
      NOMBRE_CATEGORIA
    FROM FIDE_CATEGORIAS_TB
    ORDER BY NOMBRE_CATEGORIA;

  DBMS_OUTPUT.PUT_LINE('Listado de categor�as obtenido correctamente.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al listar categor�as: ' || SQLERRM);
    OPEN p_cursor FOR
      SELECT 
        NULL AS CATEGORIA_ID,
        NULL AS ESTADO_ID,
        NULL AS NOMBRE_CATEGORIA
      FROM dual WHERE 1 = 0;
END FIDE_CATEGORIAS_LISTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_CATEGORIAS_OBTENER_SP (
  p_categoria_id IN FIDE_CATEGORIAS_TB.CATEGORIA_ID%TYPE,
  p_cursor       OUT SYS_REFCURSOR
) IS
BEGIN
  OPEN p_cursor FOR
    SELECT 
      CATEGORIA_ID,
      ESTADO_ID,
      NOMBRE_CATEGORIA
    FROM FIDE_CATEGORIAS_TB
    WHERE CATEGORIA_ID = p_categoria_id;

  DBMS_OUTPUT.PUT_LINE('Detalle de la categor�a obtenido.');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontr� la categor�a con ID: ' || p_categoria_id);
    OPEN p_cursor FOR
      SELECT 
        NULL AS CATEGORIA_ID,
        NULL AS ESTADO_ID,
        NULL AS NOMBRE_CATEGORIA
      FROM dual WHERE 1 = 0;

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al obtener categor�a: ' || SQLERRM);
    OPEN p_cursor FOR
      SELECT 
        NULL AS CATEGORIA_ID,
        NULL AS ESTADO_ID,
        NULL AS NOMBRE_CATEGORIA
      FROM dual WHERE 1 = 0;
END FIDE_CATEGORIAS_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_FACTURAS_LISTAR_SP (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            FACTURA_ID,
            CLIENTE_ID,
            ESTADO_ID,
            METODO_PAGO_ID,
            FECHA,
            IMPUESTOS,
            TOTAL
        FROM FIDE_FACTURAS_TB
        ORDER BY FECHA DESC;

    DBMS_OUTPUT.PUT_LINE('Listado de facturas obtenido correctamente.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar facturas: ' || SQLERRM);
        OPEN p_cursor FOR
            SELECT
                NULL FACTURA_ID,
                NULL CLIENTE_ID,
                NULL ESTADO_ID,
                NULL METODO_PAGO_ID,
                NULL FECHA,
                NULL IMPUESTOS,
                NULL TOTAL
            FROM dual WHERE 1=0;
END FIDE_FACTURAS_LISTAR_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_FACTURAS_OBTENER_SP (
    p_factura_id IN FIDE_FACTURAS_TB.FACTURA_ID%TYPE,
    p_cursor     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            FACTURA_ID,
            CLIENTE_ID,
            ESTADO_ID,
            METODO_PAGO_ID,
            FECHA,
            IMPUESTOS,
            TOTAL
        FROM FIDE_FACTURAS_TB
        WHERE FACTURA_ID = p_factura_id;

    DBMS_OUTPUT.PUT_LINE('Factura obtenida correctamente.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al obtener factura: ' || SQLERRM);
        OPEN p_cursor FOR
            SELECT
                NULL FACTURA_ID,
                NULL CLIENTE_ID,
                NULL ESTADO_ID,
                NULL METODO_PAGO_ID,
                NULL FECHA,
                NULL IMPUESTOS,
                NULL TOTAL
            FROM dual WHERE 1=0;
END FIDE_FACTURAS_OBTENER_SP;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE FIDE_USUARIOS_LOGIN_SP (
    p_correo     IN VARCHAR2,
    p_password   IN VARCHAR2,
    p_cursor     OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN p_cursor FOR
    SELECT 
        u.USUARIO_ID,
        u.ROL_ID,
        u.NOMBRE || ' ' || u.APELLIDO_PATERNO AS NOMBRE,
        c.CLIENTE_ID,
        cr.CORREO,
        u.ESTADO_ID
    FROM FIDE_USUARIOS_TB u
    JOIN FIDE_CORREOS_TB cr ON u.CORREO_ID = cr.CORREO_ID
    LEFT JOIN FIDE_CLIENTES_TB c ON c.USUARIO_ID = u.USUARIO_ID
    WHERE cr.CORREO = p_correo
      AND u.PASSWORD = p_password
      AND u.ESTADO_ID = 1; -- Solo activos
END FIDE_USUARIOS_LOGIN_SP;
-------------------------------------------------------------------------------------
PROCEDURE FIDE_USUARIOS_REGISTRAR_SP (
    p_nombre            IN VARCHAR2,
    p_apellido_paterno  IN VARCHAR2,
    p_apellido_materno  IN VARCHAR2,
    p_correo            IN VARCHAR2,
    p_telefono          IN VARCHAR2,
    p_password          IN VARCHAR2,
    p_usuario_id        OUT NUMBER,
    p_cliente_id        OUT NUMBER
)
IS
    v_correo_id    NUMBER;
    v_telefono_id  NUMBER;
BEGIN
    -------------------------------------------------------------------
    -- VALIDAR QUE EL CORREO NO EXISTE
    -------------------------------------------------------------------
    BEGIN
        SELECT CORREO_ID INTO v_correo_id
        FROM FIDE_CORREOS_TB
        WHERE CORREO = p_correo;

        RAISE_APPLICATION_ERROR(-20010, 'El correo ya est� registrado.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    -------------------------------------------------------------------
    -- INSERTAR CORREO
    -------------------------------------------------------------------
    INSERT INTO FIDE_CORREOS_TB (ESTADO_ID, CORREO)
    VALUES (1, p_correo)
    RETURNING CORREO_ID INTO v_correo_id;

    -------------------------------------------------------------------
    -- INSERTAR TEL�FONO
    -------------------------------------------------------------------
    INSERT INTO FIDE_TELEFONOS_TB (ESTADO_ID, TELEFONO)
    VALUES (1, p_telefono)
    RETURNING TELEFONO_ID INTO v_telefono_id;

    -------------------------------------------------------------------
    -- INSERTAR USUARIO (ROL CLIENTE = 7)
    -------------------------------------------------------------------
    INSERT INTO FIDE_USUARIOS_TB
    (ROL_ID, CORREO_ID, TELEFONO_ID, ESTADO_ID, NOMBRE,
     APELLIDO_PATERNO, APELLIDO_MATERNO, PASSWORD)
    VALUES
    (7, v_correo_id, v_telefono_id, 1,                    -- ? CAMBIO AQU�
     p_nombre, p_apellido_paterno, p_apellido_materno, p_password)
    RETURNING USUARIO_ID INTO p_usuario_id;

    -------------------------------------------------------------------
    -- CREAR CLIENTE ASOCIADO
    -------------------------------------------------------------------
    INSERT INTO FIDE_CLIENTES_TB (USUARIO_ID, ESTADO_ID)
    VALUES (p_usuario_id, 1)
    RETURNING CLIENTE_ID INTO p_cliente_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20020, 'Error al registrar usuario: ' || SQLERRM);
END FIDE_USUARIOS_REGISTRAR_SP;
----------------------------------------------------------
PROCEDURE FIDE_PAGO_PROCESAR_SP (
    p_cliente_id      IN NUMBER,
    p_metodo_pago_id  IN NUMBER,
    p_items_json      IN CLOB,
    p_factura_id      OUT NUMBER
)
IS
    v_subtotal  NUMBER := 0;
    v_impuestos NUMBER := 0;
    v_total     NUMBER := 0;
BEGIN
    -- 1) Obtener ID factura
    SELECT FIDE_FACTURAS_SEQ.NEXTVAL INTO p_factura_id FROM dual;

    -- 2) PRIMERO insertar factura en cabecera (sin totales a�n)
    INSERT INTO FIDE_FACTURAS_TB
        (FACTURA_ID, CLIENTE_ID, ESTADO_ID, METODO_PAGO_ID, FECHA, IMPUESTOS, TOTAL)
    VALUES
        (p_factura_id, p_cliente_id, 1, p_metodo_pago_id, SYSDATE, 0, 0);

    -- 3) Procesar items y agregar detalles
    FOR item IN (
        SELECT 
            jt.producto_id,
            jt.cantidad,
            jt.precio
        FROM JSON_TABLE(
            p_items_json,
            '$[*]' COLUMNS (
                producto_id NUMBER PATH '$.producto_id',
                cantidad    NUMBER PATH '$.cantidad',
                precio      NUMBER PATH '$.precio'
            )
        ) jt
    )
    LOOP
        v_subtotal := v_subtotal + (item.precio * item.cantidad);

        INSERT INTO FIDE_DETALLES_FACTURA_TB
            (FACTURA_ID, PRODUCTO_ID, ESTADO_ID, PRECIO_UNITARIO, CANTIDAD)
        VALUES
            (p_factura_id, item.producto_id, 1, item.precio, item.cantidad);
    END LOOP;

    -- 4) Calcular totales correctamente
    v_impuestos := ROUND(v_subtotal * 0.13, 2);
    v_total     := v_subtotal + v_impuestos;

    -- 5) Actualizar facturas con impuestos y total
    UPDATE FIDE_FACTURAS_TB
       SET IMPUESTOS = v_impuestos,
           TOTAL = v_total
     WHERE FACTURA_ID = p_factura_id;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20030, 'Error al procesar pago: ' || SQLERRM);
END FIDE_PAGO_PROCESAR_SP;

END FIDE_ANGELUS_ESTETICA_PKG;
/