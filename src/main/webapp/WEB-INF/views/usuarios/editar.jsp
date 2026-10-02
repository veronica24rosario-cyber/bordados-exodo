<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Editar Usuario" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:560px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-user-cog"></i> Editar usuario</span>
    </div>
    <div class="card-body">

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${error}</div>
        </c:if>
        <c:if test="${not empty exito}">
            <div class="alert alert-success"><i class="ti ti-check"></i> ${exito}</div>
        </c:if>

        <!-- Datos generales -->
        <form method="post" action="${pageContext.request.contextPath}/usuarios/actualizar">
            <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">
            <div style="font-size:13px;font-weight:600;color:#333;margin-bottom:12px;padding-bottom:8px;border-bottom:1px solid #f0f0f0;">
                Datos del usuario
            </div>
            <div class="form-group">
                <label class="form-label">Nombre completo *</label>
                <input type="text" name="nombre" class="form-control" required value="${usuario.nombre}">
            </div>
            <div class="form-group">
                <label class="form-label">Correo electrónico *</label>
                <input type="email" name="correo" class="form-control" required value="${usuario.correo}">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Rol</label>
                    <select name="rol" class="form-control">
                        <option value="OPERARIO" ${usuario.rol == 'OPERARIO' ? 'selected' : ''}>Operario</option>
                        <option value="ADMINISTRADOR" ${usuario.rol == 'ADMINISTRADOR' ? 'selected' : ''}>Administrador</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Estado</label>
                    <select name="activo" class="form-control">
                        <option value="true" ${usuario.activo ? 'selected' : ''}>Activo</option>
                        <option value="false" ${!usuario.activo ? 'selected' : ''}>Inactivo</option>
                    </select>
                </div>
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Guardar cambios
                </button>
            </div>
        </form>

        <!-- Cambiar contraseña del usuario -->
        <div style="margin-top:24px;padding-top:20px;border-top:1px solid #f0f0f0;">
            <div style="font-size:13px;font-weight:600;color:#333;margin-bottom:12px;">
                <i class="ti ti-lock"></i> Restablecer contraseña
            </div>
            <form method="post" action="${pageContext.request.contextPath}/usuarios/resetear-contrasena">
                <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Nueva contraseña *</label>
                        <input type="password" name="nuevaContrasena" class="form-control"
                               required placeholder="Mínimo 6 caracteres" minlength="6">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Confirmar *</label>
                        <input type="password" name="confirmar" class="form-control"
                               required placeholder="Repite la contraseña">
                    </div>
                </div>
                <div style="display:flex;justify-content:flex-end;">
                    <button type="submit" class="btn btn-danger btn-sm">
                        <i class="ti ti-lock-open"></i> Restablecer contraseña
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
