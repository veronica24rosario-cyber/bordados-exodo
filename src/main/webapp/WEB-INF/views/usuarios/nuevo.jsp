<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Nuevo Usuario" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:560px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-user-plus"></i> Crear nuevo usuario</span>
    </div>
    <div class="card-body">

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/usuarios/guardar">
            <div class="form-group">
                <label class="form-label">Nombre completo *</label>
                <input type="text" name="nombre" class="form-control" required placeholder="Ej: María López">
            </div>
            <div class="form-group">
                <label class="form-label">Correo electrónico *</label>
                <input type="email" name="correo" class="form-control" required placeholder="correo@ejemplo.com">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Contraseña *</label>
                    <input type="password" name="contrasena" class="form-control" required
                           placeholder="Mínimo 6 caracteres" minlength="6" id="pass1">
                </div>
                <div class="form-group">
                    <label class="form-label">Confirmar contraseña *</label>
                    <input type="password" name="confirmar" class="form-control" required
                           placeholder="Repite la contraseña" id="pass2">
                    <small id="msg" style="font-size:11px;margin-top:4px;display:block;"></small>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Rol *</label>
                <select name="rol" class="form-control" required>
                    <option value="OPERARIO">Operario</option>
                    <option value="ADMINISTRADOR">Administrador</option>
                </select>
                <small style="color:#888;font-size:11px;margin-top:4px;display:block;">
                    El operario puede consultar pedidos e inventario. El administrador tiene acceso completo.
                </small>
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary" id="btnGuardar">
                    <i class="ti ti-check"></i> Crear usuario
                </button>
            </div>
        </form>
    </div>
</div>

<script>
const p1 = document.getElementById('pass1');
const p2 = document.getElementById('pass2');
const msg = document.getElementById('msg');
const btn = document.getElementById('btnGuardar');

function verificar() {
    if (!p2.value) { msg.textContent = ''; return; }
    if (p1.value === p2.value) {
        msg.textContent = '✅ Las contraseñas coinciden';
        msg.style.color = '#2e7d32';
        btn.disabled = false;
    } else {
        msg.textContent = '❌ Las contraseñas no coinciden';
        msg.style.color = '#c62828';
        btn.disabled = true;
    }
}
p1.addEventListener('input', verificar);
p2.addEventListener('input', verificar);
</script>

<%@ include file="../includes/footer.jsp" %>
