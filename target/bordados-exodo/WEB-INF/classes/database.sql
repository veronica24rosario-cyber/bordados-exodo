-- ============================================================
--  BASE DE DATOS: Bordados Éxodo
--  Sistema de gestión de pedidos e inventario
--  Puerto MySQL: 3307
-- ============================================================

CREATE DATABASE IF NOT EXISTS bordados_exodo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bordados_exodo;

-- TABLA: usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('ADMINISTRADOR','OPERARIO') NOT NULL DEFAULT 'OPERARIO',
    activo TINYINT(1) DEFAULT 1,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLA: clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(150),
    direccion VARCHAR(255),
    activo TINYINT(1) DEFAULT 1,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLA: pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    descripcion TEXT NOT NULL,
    cantidad INT NOT NULL,
    diseno VARCHAR(100),
    notas TEXT,
    fecha_recepcion DATE NOT NULL,
    fecha_entrega DATE NOT NULL,
    estado ENUM('RECIBIDO','EN_PROCESO','TERMINADO','ENTREGADO','CANCELADO') NOT NULL DEFAULT 'RECIBIDO',
    id_usuario_registro INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_usuario_registro) REFERENCES usuarios(id_usuario)
);

-- TABLA: inventario
CREATE TABLE IF NOT EXISTS inventario (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    nombre_material VARCHAR(150) NOT NULL,
    existencias DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10,2) NOT NULL DEFAULT 0,
    unidad VARCHAR(30) NOT NULL,
    consumo_mensual DECIMAL(10,2) DEFAULT 0,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABLA: movimientos_inventario
CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_material INT NOT NULL,
    tipo ENUM('COMPRA','CONSUMO','AJUSTE') NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255),
    id_usuario INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_material) REFERENCES inventario(id_material),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- TABLA: alertas
CREATE TABLE IF NOT EXISTS alertas (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('ENTREGA_1DIA','ENTREGA_3DIAS','STOCK_MINIMO') NOT NULL,
    id_pedido INT,
    id_material INT,
    mensaje TEXT NOT NULL,
    leida TINYINT(1) DEFAULT 0,
    correo_enviado TINYINT(1) DEFAULT 0,
    fecha_alerta DATETIME NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_material) REFERENCES inventario(id_material)
);

-- ============================================================
--  DATOS INICIALES
-- ============================================================

-- Usuario administrador
-- Contrasena: admin123
INSERT INTO usuarios (nombre, correo, contrasena, rol) VALUES
('Administrador', 'admin@bordados-exodo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh7S', 'ADMINISTRADOR');

-- Clientes de ejemplo
INSERT INTO clientes (nombre, telefono, correo, direccion) VALUES
('Colegio San José', '2222-3333', 'compras@sanjose.edu.gt', 'Zona 10, Guatemala'),
('Empresa ABC', '4444-5555', 'pedidos@empresaabc.com', 'Zona 4, Guatemala'),
('Club Deportivo Azteca', '6666-7777', 'uniformes@azteca.com', 'Zona 6, Guatemala');

-- Materiales de ejemplo
INSERT INTO inventario (nombre_material, existencias, stock_minimo, unidad, consumo_mensual) VALUES
('Hilo blanco', 2, 5, 'Carrete', 8),
('Hilo negro', 12, 5, 'Carrete', 10),
('Hilo rojo', 20, 5, 'Carrete', 6),
('Tela base beige', 3, 10, 'Metro', 15),
('Agujas #75', 8, 10, 'Unidad', 5),
('Aceite para maquinaria', 2, 3, 'Litro', 1);

-- ============================================================
--  NUEVAS COLUMNAS PARA FOTOS Y ELIMINACIÓN LÓGICA
-- ============================================================

-- Foto de perfil de usuario
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS foto LONGBLOB;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS foto_tipo VARCHAR(50);

-- Foto de referencia en pedidos
ALTER TABLE pedidos ADD COLUMN IF NOT EXISTS foto_referencia LONGBLOB;
ALTER TABLE pedidos ADD COLUMN IF NOT EXISTS foto_referencia_tipo VARCHAR(50);
ALTER TABLE pedidos ADD COLUMN IF NOT EXISTS oculto TINYINT(1) DEFAULT 0;

-- Foto de material en inventario
ALTER TABLE inventario ADD COLUMN IF NOT EXISTS foto LONGBLOB;
ALTER TABLE inventario ADD COLUMN IF NOT EXISTS foto_tipo VARCHAR(50);

-- Eliminación lógica en clientes
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS eliminado TINYINT(1) DEFAULT 0;
