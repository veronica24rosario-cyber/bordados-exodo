# Sistema Bordados Éxodo
## Guía de instalación y configuración

---

## Requisitos
- Java 11 o superior
- Apache Tomcat 10.x
- MySQL 8.x
- Maven 3.x
- IDE: IntelliJ IDEA o Eclipse

---

## Paso 1 — Configurar la base de datos

1. Abre MySQL Workbench o la terminal de MySQL
2. Ejecuta el archivo: `src/main/resources/database.sql`
3. Esto creará la base de datos, las tablas y los datos iniciales

---

## Paso 2 — Configurar la conexión a MySQL

Abre el archivo:
```
src/main/java/com/bordados/util/ConexionDB.java
```

Cambia estos valores:
```java
private static final String USUARIO  = "root";         // Tu usuario MySQL
private static final String PASSWORD = "tu_password";  // Tu contraseña MySQL
```

---

## Paso 3 — Configurar el correo para alertas (Gmail)

### Preparar tu cuenta Gmail:
1. Ve a tu cuenta Google → Seguridad
2. Activa "Verificación en 2 pasos"
3. Ve a: Seguridad → Contraseñas de aplicación
4. Selecciona "Otra (nombre personalizado)" → escribe "Bordados Exodo"
5. Copia la contraseña de 16 caracteres que genera Google

### Configurar en el sistema:
Abre el archivo:
```
src/main/java/com/bordados/util/CorreoUtil.java
```

Cambia estos valores:
```java
private static final String CORREO_ORIGEN  = "tu_correo@gmail.com";
private static final String PASSWORD_APP   = "xxxx xxxx xxxx xxxx"; // Contraseña de app Gmail
private static final String CORREO_DESTINO = "admin@tu-dominio.com"; // Correo del administrador
```

---

## Paso 4 — Compilar el proyecto

Desde la carpeta raíz del proyecto:
```bash
mvn clean package
```

Esto generará el archivo: `target/bordados-exodo.war`

---

## Paso 5 — Desplegar en Tomcat

1. Copia el archivo `bordados-exodo.war` a la carpeta `webapps/` de Tomcat
2. Inicia Tomcat
3. Abre el navegador: `http://localhost:8080/bordados-exodo`

---

## Credenciales iniciales

| Campo    | Valor                      |
|----------|---------------------------|
| Correo   | admin@bordados-exodo.com  |
| Contraseña | admin123                |

---

## Funcionalidades del sistema

### Módulo de Pedidos
- Registrar nuevos pedidos con datos del cliente, descripción, cantidad, fechas
- Ver lista de pedidos filtrados por estado
- Actualizar el estado de cada pedido
- Alertas automáticas programadas al crear un pedido

### Módulo de Inventario
- Registrar materiales con stock mínimo
- Registrar movimientos: Compra, Consumo mensual, Ajuste
- Alertas automáticas cuando el stock baja del mínimo

### Sistema de Alertas
- Alerta 3 días antes de la fecha de entrega de un pedido
- Alerta 1 día antes de la fecha de entrega
- Alerta cuando un material llega al stock mínimo
- Correos automáticos enviados via Gmail SMTP (gratuito)
- Verificación automática cada hora mediante Quartz Scheduler

### Módulo de Clientes
- Registrar y gestionar clientes del negocio

### Control de Acceso
- Roles: Administrador y Operario
- El administrador tiene acceso a todas las funciones
- El operario puede consultar pedidos e inventario

---

## Estructura del proyecto

```
bordados-exodo/
├── src/main/java/com/bordados/
│   ├── model/          → Clases de datos (Pedido, Cliente, etc.)
│   ├── dao/            → Acceso a base de datos
│   ├── service/        → Lógica de negocio y alertas
│   ├── servlet/        → Controladores HTTP
│   └── util/           → Utilidades (BD, Correo)
├── src/main/webapp/
│   ├── WEB-INF/views/  → Vistas JSP
│   ├── css/            → Hojas de estilo
│   └── js/             → JavaScript
└── src/main/resources/
    └── database.sql    → Script de base de datos
```

---

## Tecnologías utilizadas
- **Java 11** — Lenguaje de programación
- **Jakarta Servlet 5.0** — Controladores web
- **JSP + JSTL** — Vistas
- **MySQL 8** — Base de datos
- **BCrypt** — Encriptación de contraseñas
- **JavaMail + Gmail SMTP** — Envío de correos (gratuito)
- **Quartz Scheduler** — Verificación automática de alertas cada hora
- **Bootstrap Icons (Tabler)** — Iconografía
- **Maven** — Gestión de dependencias
