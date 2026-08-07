/* Sobre la base de datos Ventas_Tech_DB creada en M3, escribí las siguientes consultas en un archivo llamado m4_consultas_negocio.sql. 
Trabajamos solo sobre la tabla ventas (recordá que tiene id_cliente, id_producto, cantidad, precio_unitario y fecha_venta).
Los nombres de productos y clientes los vas a poder traer cruzando tablas con JOIN en el Módulo 5; por ahora trabajamos con los IDs.
*/

USE Ventas_Tech_DB;
SELECT *
FROM Ventas;


-- Consulta 1 — 
-- Resumen ejecutivo mensual: Resumen ejecutivo mensual Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. Calculá el total como cantidad * precio_unitario. Usá alias descriptivos en español y agrupá por mes con EXTRACT(MONTH FROM fecha_venta).

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);


--- Consulta 2 — 
/* Ranking de productos Top 5 de id_producto por total facturado, mostrando las unidades vendidas (SUM(cantidad)) y el total generado. 
Usá GROUP BY id_producto, ORDER BY y limitá el resultado a 5.*/

SELECT TOP 5
       id_producto,
       SUM(cantidad) AS Unidades_vendidas,
       SUM(cantidad * precio_unitario) AS total_facturado
FROM Ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--- Consulta 3
-- Clientes recurrentes id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. Usá GROUP BY id_cliente y HAVING COUNT(*) > 1.

SELECT
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM Ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


--- Consulta 4 
-- Meses por encima/por debajo del promedio Total facturado por mes, con una columna adicional que etiquete con CASE WHEN si ese mes quedó 'Por encima' o 'Por debajo' del promedio mensual general.

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    AVG(total_facturado) OVER () AS promedio_mensual,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
            THEN 'Por encima'
        WHEN total_facturado < AVG(total_facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Igual'
    END AS comparacion
FROM facturacion_mensual
ORDER BY mes;

/* Bloque de cierre Al final del archivo agregá un bloque de comentarios -- con 3 hallazgos concretos que encontraste al revisar los resultados. 
Por ejemplo: "El producto 1 concentra el 40% de la facturación del trimestre."/*

/* Hallazgos:

Si bien el producto 1 es el que genera el mayor monto de facturación (más del 50%) este no es el producto más vendido en unidades. 
Hay varios clientes que han realizado más de un pedido, pero se debe resaltar al 1 y al 5 ya que entre ambos concentran el 73% de la facturación del mes.
En el mes de Marzo, el total facturado es de 6444 USD, generando un ticket promedio de 644.4 USD. 

/*