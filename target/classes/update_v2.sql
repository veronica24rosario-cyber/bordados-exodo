-- ============================================================
--  SCRIPT DE ACTUALIZACIÓN v2
--  Ejecuta esto en MySQL Workbench si ya tenías la base de datos
-- ============================================================
USE bordados_exodo;

ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS foto LONGBLOB;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS foto_tipo VARCHAR(50);

ALTER TABLE pedidos ADD COLUMN IF NOT EXISTS foto_referencia LONGBLOB;
ALTER TABLE pedidos ADD COLUMN IF NOT EXISTS foto_referencia_tipo VARCHAR(50);
ALTER TABLE pedidos ADD COLUMN IF NOT EXISTS oculto TINYINT(1) DEFAULT 0;

ALTER TABLE inventario ADD COLUMN IF NOT EXISTS foto LONGBLOB;
ALTER TABLE inventario ADD COLUMN IF NOT EXISTS foto_tipo VARCHAR(50);

ALTER TABLE clientes ADD COLUMN IF NOT EXISTS eliminado TINYINT(1) DEFAULT 0;

-- Columnas de pago en pedidos
ALTER TABLE pedidos ADD COLUMN total DECIMAL(10,2) DEFAULT 0;
ALTER TABLE pedidos ADD COLUMN anticipo DECIMAL(10,2) DEFAULT 0;

-- Tabla de papelera para pedidos eliminados (30 días)
CREATE TABLE IF NOT EXISTS papelera_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido_original INT,
    id_cliente INT,
    cliente_nombre VARCHAR(150),
    descripcion TEXT,
    cantidad INT,
    diseno VARCHAR(100),
    notas TEXT,
    fecha_recepcion DATE,
    fecha_entrega DATE,
    estado VARCHAR(20),
    total DECIMAL(10,2) DEFAULT 0,
    anticipo DECIMAL(10,2) DEFAULT 0,
    fecha_eliminado DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de papelera para inventario eliminado (30 días)
CREATE TABLE IF NOT EXISTS papelera_inventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_material_original INT,
    nombre_material VARCHAR(150),
    existencias DECIMAL(10,2),
    stock_minimo DECIMAL(10,2),
    unidad VARCHAR(30),
    consumo_mensual DECIMAL(10,2),
    fecha_eliminado DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de configuración del sistema
CREATE TABLE IF NOT EXISTS configuracion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT,
    descripcion VARCHAR(255),
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Valores iniciales
INSERT IGNORE INTO configuracion (clave, valor, descripcion) VALUES
('correo_origen', '', 'Correo Gmail que envía las notificaciones'),
('correo_password', '', 'Contraseña de aplicación de Gmail (16 caracteres)'),
('correo_destino', '', 'Correo que recibe las notificaciones'),
('notificaciones_activas', 'true', 'Activar o desactivar notificaciones por correo');
