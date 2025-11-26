-----Se recorre la base de datos buscando un ID y devuelve el usuario
CREATE OR REPLACE FUNCTION USUARIOS_OBTENER_NOMBRE_USUARIO_FN(
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
    
    ----Si no se encontró ningún registro se muestra otro mensaje
    IF NOT V_ENCONTRADO THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el usuario con ID: ' || P_USUARIO_ID);
        V_NOMBRE_COMPLETO := 'Usuario no encontrado';
    END IF;
    
    RETURN V_NOMBRE_COMPLETO;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        RETURN 'Error al buscar usuario';
END;
/
---Prueba de función y cursor
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(USUARIOS_OBTENER_NOMBRE_USUARIO_FN(10));
END;
/
-----Se recorre la base de datos para mostrar las citas pendientes
CREATE OR REPLACE FUNCTION CITAS_OBTENER_PENDIENTES_FN 
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
END;
/
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CITAS_OBTENER_PENDIENTES_FN);
END;
/
CREATE OR REPLACE FUNCTION INVENTARIO_OBTENER_BAJO_STOCK_FN(
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
    V_RESULTADO := 'PRODUCTOS CON BAJO STOCK (CANTIDAD MÍNIMA: ' || P_MINIMO || '):' || CHR(10) || CHR(10);
    
    FOR REGISTRO IN C_PRODUCTOS_BAJO_STOCK LOOP
        V_CONTADOR := V_CONTADOR + 1;
        
        V_RESULTADO := V_RESULTADO || 
                     'Producto #' || V_CONTADOR || CHR(10) ||
                     'Nombre: ' || REGISTRO.PRODUCTO || CHR(10) ||
                     'Stock actual: ' || REGISTRO.CANTIDAD || CHR(10) ||
                     'Categoría: ' || REGISTRO.CATEGORIA || CHR(10) ||
                     'Proveedor: ' || REGISTRO.PROVEEDOR || CHR(10) ||
                     '------------------------------------' || CHR(10);
    END LOOP;
    
    IF V_CONTADOR = 0 THEN
        V_RESULTADO := V_RESULTADO || 'No hay productos con stock bajo.';
    ELSE
        V_RESULTADO := V_RESULTADO || CHR(10) || 'Total: ' || V_CONTADOR || ' productos requieren atención';
    END IF;
    
    RETURN V_RESULTADO;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al obtener productos con bajo stock: ' || SQLERRM;
END;
/
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(INVENTARIO_OBTENER_BAJO_STOCK_FN);
END;
/
CREATE OR REPLACE FUNCTION CITAS_OBTENER_DEL_DIA_FN
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
        RETURN 'Error al obtener citas del día: ' || SQLERRM;
END;
/
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CITAS_OBTENER_DEL_DIA_FN);
END;