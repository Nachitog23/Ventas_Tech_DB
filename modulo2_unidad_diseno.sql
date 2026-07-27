-- Crear base de datos
CREATE DATABASE modulo2_unidad1_diseno
;

-- crear tabla de clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nombre VARCHAR(100), 
    perfil_bio TEXT,
fecha_registro DATE,
);

-- Crear tabla de productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    description VARCHAR (255),
    precio DECIMAL (10, 2),
    esta_disponible VARCHAR (3),
);

-- Verificar la estructura de las tablas
SELECT * FROM clientes;
SELECT * FROM productos;