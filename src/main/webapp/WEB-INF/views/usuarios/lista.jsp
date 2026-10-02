<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Gestión de Usuarios" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<c:if test="${param.exito == 'creado'}">
    <div class="alert alert-success"><i class="ti ti-check"></i> Usuario creado exitosamente.</div>
</c:if>
<c:if test="${param.exito == 'actualizado'}">
    <div class="alert alert-success"><i class="ti ti-check"></i> Usuario actualizado exitosamente.</div>
</c:if>
<c:if test="${param.exito == 'eliminado'}">
    <div class="alert alert-success"><i class="ti ti-check"></i> Usuario eliminado exitosamente.</div>
</c:if>
<c:if test="${not empty errorEliminar}">
    <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${errorEliminar}</div>
</c:if>

<div style="display:flex; justify-content:flex-end; margin-bottom:16px;">
    <a href="${pageContext.request.contextPath}/usuarios/nuevo" class="btn btn-primary btn-sm">
        <i class="ti ti-user-plus"></i> Nuevo usuario
    </a>
</div>

<div class="card">
    <table class="tabla">
        <thead>
            <tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Rol</th><th>Estado</th><th>Acciones</th></tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty usuarios}">
                <tr><td colspan="6" style="text-align:center; color:#aaa; padding:40px;">No hay usuarios registrados</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="u" items="${usuarios}">
                    <tr>
                        <td>${u.idUsuario}</td>
                        <td><strong>${u.nombre}</strong></td>
                        <td>${u.correo}</td>
                        <td>
                            <span class="badge ${u.rol == 'ADMINISTRADOR' ? 'badge-blue' : 'badge-green'}">
                                ${u.rol == 'ADMINISTRADOR' ? 'Administrador' : 'Operario'}
                            </span>
                        </td>
                        <td>
                            <span class="badge ${u.activo ? 'badge-green' : 'badge-red'}">
                                ${u.activo ? 'Activo' : 'Inactivo'}
                            </span>
                        </td>
                        <td style="display:flex; gap:4px;">
                            <a href="${pageContext.request.contextPath}/usuarios/editar?id=${u.idUsuario}"
                               class="btn btn-secondary btn-sm" title="Editar">
                                <i class="ti ti-edit"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/usuarios/eliminar?id=${u.idUsuario}"
                               class="btn btn-secondary btn-sm" title="Eliminar usuario"
                               onclick="return confirm('¿Eliminar al usuario ${u.nombre}? Esta acción no se puede deshacer.')">
                                <i class="ti ti-trash" style="color:#e53935;"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

<%@ include file="../includes/footer.jsp" %>
