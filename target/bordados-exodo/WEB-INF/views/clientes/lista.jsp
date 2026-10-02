<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Clientes" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<c:if test="${param.exito == 'creado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Cliente registrado exitosamente.</div></c:if>
<c:if test="${param.exito == 'actualizado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Cliente actualizado.</div></c:if>
<c:if test="${param.exito == 'eliminado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Cliente eliminado exitosamente.</div></c:if>

<div style="display:flex; justify-content:flex-end; margin-bottom:16px;">
    <a href="${pageContext.request.contextPath}/clientes/nuevo" class="btn btn-primary btn-sm">
        <i class="ti ti-plus"></i> Nuevo cliente
    </a>
</div>

<div class="card">
    <table class="tabla">
        <thead><tr><th>ID</th><th>Nombre</th><th>Teléfono</th><th>Correo</th><th>Dirección</th><th>Acciones</th></tr></thead>
        <tbody>
        <c:choose>
            <c:when test="${empty clientes}">
                <tr><td colspan="6" style="text-align:center;color:#aaa;padding:40px;">No hay clientes registrados</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="c" items="${clientes}">
                    <tr>
                        <td>${c.idCliente}</td>
                        <td><strong>${c.nombre}</strong></td>
                        <td>${c.telefono}</td>
                        <td>${c.correo}</td>
                        <td>${c.direccion}</td>
                        <td style="display:flex;gap:4px;">
                            <a href="${pageContext.request.contextPath}/clientes/editar?id=${c.idCliente}" class="btn btn-secondary btn-sm" title="Editar">
                                <i class="ti ti-edit"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/clientes/eliminar?id=${c.idCliente}"
                               class="btn btn-secondary btn-sm" title="Eliminar"
                               onclick="return confirm('¿Eliminar el cliente ${c.nombre}? Sus pedidos se mantendrán en el sistema.')">
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
