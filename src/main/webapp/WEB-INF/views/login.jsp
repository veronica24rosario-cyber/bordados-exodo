<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión — Bordados Éxodo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@2.44.0/tabler-icons.min.css">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-logo">
            <div style="font-size:40px; color:#1976D2; margin-bottom:8px;">
                <i class="ti ti-needle-thread"></i>
            </div>
            <div class="title">Bordados Éxodo</div>
            <div class="sub">Sistema de gestión de pedidos e inventario</div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" style="margin-bottom:16px;">
            <i class="ti ti-alert-circle"></i>
            ${error}
        </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label class="form-label">Correo electrónico</label>
                <input type="email" name="correo" class="form-control" placeholder="admin@bordados-exodo.com" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label">Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; justify-content:center; padding:10px; margin-top:8px;">
                <i class="ti ti-login"></i> Ingresar al sistema
            </button>
        </form>

        <div style="text-align:center; margin-top:20px; font-size:11px; color:#bbb;">
            Usuario inicial: admin@bordados-exodo.com / admin123
        </div>
    </div>
</div>
</body>
</html>
