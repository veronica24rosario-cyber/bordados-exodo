<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Inventario" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<c:if test="${param.exito == 'creado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Material registrado.</div></c:if>
<c:if test="${param.exito == 'movimiento'}"><div class="alert alert-success"><i class="ti ti-check"></i> Movimiento registrado.</div></c:if>
<c:if test="${param.exito == 'eliminado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Material eliminado.</div></c:if>

<c:if test="${stockBajo > 0}">
    <div class="alert alert-danger">
        <i class="ti ti-alert-triangle"></i>
        Hay <strong>${stockBajo}</strong> material(es) por debajo del stock mínimo.
    </div>
</c:if>

<div style="display:flex; justify-content:flex-end; gap:8px; margin-bottom:16px;">
    <a href="${pageContext.request.contextPath}/inventario/nuevo" class="btn btn-primary btn-sm">
        <i class="ti ti-plus"></i> Nuevo material
    </a>
</div>

<div class="card">
    <table class="tabla">
        <thead>
            <tr><th>Foto</th><th>Material</th><th>Existencias</th><th>Stock mín.</th><th>Unidad</th><th>Consumo mensual</th><th>Estado</th><th>Acciones</th></tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty materiales}">
                <tr><td colspan="8" style="text-align:center;color:#aaa;padding:40px;">No hay materiales registrados</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="m" items="${materiales}">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${m.tieneFoto()}">
                                    <img src="${pageContext.request.contextPath}/foto/material/${m.idMaterial}"
                                         style="width:44px;height:44px;border-radius:6px;object-fit:cover;border:1px solid #e0e0e0;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:44px;height:44px;border-radius:6px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#ccc;">
                                        <i class="ti ti-package" style="font-size:20px;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><strong>${m.nombreMaterial}</strong></td>
                        <td>${m.existencias}</td>
                        <td>${m.stockMinimo}</td>
                        <td>${m.unidad}</td>
                        <td>${m.consumoMensual}</td>
                        <td><span class="badge badge-${m.claseEstado}">${m.estadoStock}</span></td>
                        <td style="display:flex;gap:4px;align-items:center;">
                            <a href="${pageContext.request.contextPath}/inventario/movimiento?id=${m.idMaterial}" class="btn btn-primary btn-sm" title="Registrar movimiento">
                                <i class="ti ti-transfer"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/inventario/editar?id=${m.idMaterial}" class="btn btn-secondary btn-sm" title="Editar">
                                <i class="ti ti-edit"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/inventario/eliminar?id=${m.idMaterial}"
                               class="btn btn-secondary btn-sm" title="Eliminar"
                               onclick="return confirm('¿Eliminar el material ${m.nombreMaterial}?')">
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
