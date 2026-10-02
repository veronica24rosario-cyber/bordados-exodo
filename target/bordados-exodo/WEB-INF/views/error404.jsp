<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Página no encontrada</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body style="display:flex; align-items:center; justify-content:center; min-height:100vh; background:#f0f2f5;">
    <div style="text-align:center;">
        <div style="font-size:80px; color:#ddd;">404</div>
        <h2 style="color:#333; margin-bottom:16px;">Página no encontrada</h2>
        <a href="${pageContext.request.contextPath}/dashboard" style="background:#1976D2; color:#fff; padding:10px 20px; border-radius:6px; text-decoration:none;">
            Volver al inicio
        </a>
    </div>
</body>
</html>
