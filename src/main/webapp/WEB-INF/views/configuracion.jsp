<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Configuración" scope="request"/>
<%@ include file="includes/header.jsp" %>

<div class="card" style="max-width:620px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-settings"></i> Configuración del sistema</span>
    </div>
    <div class="card-body">

        <c:if test="${not empty exito}">
            <div class="alert alert-success"><i class="ti ti-check"></i> ${exito}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/configuracion">

            <!-- Notificaciones por correo -->
            <div style="background:#f8f9fa;border:1px solid #e8e8e8;border-radius:8px;padding:16px;margin-bottom:20px;">
                <div style="font-size:13px;font-weight:600;color:#333;margin-bottom:14px;">
                    <i class="ti ti-mail"></i> Notificaciones por correo
                </div>

                <!-- Activar/desactivar -->
                <div class="form-group">
                    <label style="display:flex;align-items:center;gap:10px;cursor:pointer;">
                        <input type="checkbox" name="notificaciones_activas"
                               ${config['notificaciones_activas'] == 'true' ? 'checked' : ''}
                               style="width:18px;height:18px;cursor:pointer;">
                        <span style="font-size:13px;font-weight:500;">Activar notificaciones por correo</span>
                    </label>
                    <small style="color:#888;font-size:11px;margin-top:4px;display:block;">
                        Se enviarán alertas 3 días y 1 día antes de la fecha de entrega, y cuando el stock esté bajo.
                    </small>
                </div>

                <!-- Correo que envía -->
                <div class="form-group">
                    <label class="form-label">Correo Gmail que envía las alertas *</label>
                    <input type="email" name="correo_origen" class="form-control"
                           value="${config['correo_origen']}"
                           placeholder="tucorreo@gmail.com">
                </div>

                <!-- Contraseña de aplicación -->
                <div class="form-group">
                    <label class="form-label">Contraseña de aplicación Gmail</label>
                    <input type="password" name="correo_password" class="form-control"
                           placeholder="${not empty config['correo_password'] ? '••••••••••••••••' : 'Ingresa los 16 caracteres'}">
                    <small style="color:#888;font-size:11px;margin-top:4px;display:block;">
                        Obtén tu contraseña en: <strong>Google Account → Seguridad → Contraseñas de aplicaciones</strong>.
                        Déjalo vacío para no cambiarla.
                    </small>
                </div>

                <!-- Correo que recibe -->
                <div class="form-group">
                    <label class="form-label">Correo que recibe las notificaciones *</label>
                    <input type="email" name="correo_destino" class="form-control"
                           value="${config['correo_destino']}"
                           placeholder="administrador@ejemplo.com">
                    <small style="color:#888;font-size:11px;margin-top:4px;display:block;">
                        Puede ser diferente al correo que envía. Aquí llegarán todas las alertas.
                    </small>
                </div>
            </div>

            <div class="form-actions" style="justify-content:space-between;">
                <a href="${pageContext.request.contextPath}/configuracion/probar-correo"
                   class="btn btn-secondary"
                   onclick="return confirm('¿Enviar un correo de prueba para verificar la configuración?')">
                    <i class="ti ti-send"></i> Probar correo
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Guardar configuración
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
