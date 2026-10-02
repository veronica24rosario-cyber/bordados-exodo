<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${vistaOcultos ? 'Pedidos ocultos' : 'Pedidos'}" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<c:if test="${param.exito == 'creado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Pedido registrado exitosamente.</div></c:if>
<c:if test="${param.exito == 'actualizado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Pedido actualizado.</div></c:if>
<c:if test="${param.exito == 'eliminado'}"><div class="alert alert-success"><i class="ti ti-check"></i> Pedido eliminado.</div></c:if>

<c:choose>
<%-- ==================== VISTA DE ELIMINADOS ==================== --%>
<c:when test="${vistaEliminados}">
    <div class="alert alert-warning" style="margin-bottom:16px;">
        <i class="ti ti-trash"></i>
        Pedidos eliminados en los últimos 30 días. Después de 30 días se borran permanentemente.
    </div>
    <div style="margin-bottom:16px;">
        <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary btn-sm">
            <i class="ti ti-arrow-left"></i> Volver a pedidos
        </a>
    </div>
    <div class="card">
        <div style="overflow-x:auto;">
        <table class="tabla">
            <thead>
                <tr>
                    <th>ID Original</th><th>Cliente</th><th>Descripción</th>
                    <th>Cant.</th><th>Total (Q)</th><th>Anticipo (Q)</th><th>Restante (Q)</th>
                    <th>Entrega</th><th>Estado</th><th>Fecha eliminado</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty pedidos}">
                    <tr><td colspan="10" style="text-align:center;color:#aaa;padding:40px;">No hay pedidos eliminados en los últimos 30 días</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${pedidos}">
                        <tr style="opacity:0.7;background:#fff5f5;">
                            <td><strong>#${p.idPedido}</strong></td>
                            <td>${p.clienteNombre}</td>
                            <td>${p.descripcion}</td>
                            <td>${p.cantidad}</td>
                            <td>${p.total}</td>
                            <td>${p.anticipo}</td>
                            <td style="font-weight:600;color:#e53935;">${p.restante}</td>
                            <td>${p.fechaEntrega}</td>
                            <td><span class="badge badge-gray">${p.estadoEtiqueta}</span></td>
                            <td style="font-size:11px;color:#aaa;">${p.fechaCreacion}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
        </div>
    </div>
</c:when>

<%-- ==================== VISTA DE OCULTOS ==================== --%>
<c:when test="${vistaOcultos}">
    <div class="alert alert-info" style="margin-bottom:16px;">
        <i class="ti ti-eye-off"></i>
        Estás viendo los pedidos ocultos. Puedes restaurarlos para que vuelvan a aparecer en la lista principal.
    </div>
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
        <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary btn-sm">
            <i class="ti ti-arrow-left"></i> Volver a pedidos
        </a>
    </div>
    <div class="card">
        <table class="tabla">
            <thead>
                <tr>
                    <th>ID</th><th>Foto</th><th>Cliente</th><th>Descripción</th>
                    <th>Cant.</th><th>Total (Q)</th><th>Anticipo (Q)</th><th>Restante (Q)</th>
                    <th>Entrega</th><th>Estado</th><th>Acciones</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty pedidos}">
                    <tr><td colspan="11" style="text-align:center;color:#aaa;padding:40px;">No hay pedidos ocultos</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${pedidos}">
                        <tr style="opacity:0.75;">
                            <td><strong>#${p.idPedido}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.tieneFoto()}">
                                        <img src="${pageContext.request.contextPath}/foto/pedido/${p.idPedido}"
                                             style="width:36px;height:36px;border-radius:6px;object-fit:cover;border:1px solid #e0e0e0;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:36px;height:36px;border-radius:6px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#ccc;">
                                            <i class="ti ti-photo" style="font-size:16px;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${p.clienteNombre}</td>
                            <td>${p.descripcion}</td>
                            <td>${p.cantidad}</td>
                            <td>${p.total}</td>
                            <td>${p.anticipo}</td>
                            <td style="font-weight:600;color:${p.restante > 0 ? '#e53935' : '#2e7d32'};">${p.restante}</td>
                            <td>${p.fechaEntrega}</td>
                            <td><span class="badge badge-${p.estadoClase}">${p.estadoEtiqueta}</span></td>
                            <td style="display:flex;gap:4px;">
                                <a href="${pageContext.request.contextPath}/pedidos/restaurar?id=${p.idPedido}"
                                   class="btn btn-secondary btn-sm" title="Restaurar"
                                   onclick="return confirm('¿Restaurar este pedido a la lista principal?')">
                                    <i class="ti ti-eye" style="color:#1976D2;"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/pedidos/eliminar?id=${p.idPedido}"
                                   class="btn btn-secondary btn-sm" title="Eliminar definitivamente"
                                   onclick="return confirm('¿Eliminar definitivamente este pedido? Esta acción no se puede deshacer.')">
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
</c:when>

<%-- ==================== VISTA NORMAL ==================== --%>
<c:otherwise>
    <div style="display:flex; gap:8px; margin-bottom:16px; flex-wrap:wrap; align-items:center;">
        <a href="${pageContext.request.contextPath}/pedidos" class="btn ${empty estadoFiltro ? 'btn-primary' : 'btn-secondary'} btn-sm">Todos</a>
        <a href="${pageContext.request.contextPath}/pedidos?estado=RECIBIDO" class="btn ${estadoFiltro == 'RECIBIDO' ? 'btn-primary' : 'btn-secondary'} btn-sm">Recibidos</a>
        <a href="${pageContext.request.contextPath}/pedidos?estado=EN_PROCESO" class="btn ${estadoFiltro == 'EN_PROCESO' ? 'btn-primary' : 'btn-secondary'} btn-sm">En proceso</a>
        <a href="${pageContext.request.contextPath}/pedidos?estado=TERMINADO" class="btn ${estadoFiltro == 'TERMINADO' ? 'btn-primary' : 'btn-secondary'} btn-sm">Terminados</a>
        <a href="${pageContext.request.contextPath}/pedidos?estado=ENTREGADO" class="btn ${estadoFiltro == 'ENTREGADO' ? 'btn-primary' : 'btn-secondary'} btn-sm">Entregados</a>
        <a href="${pageContext.request.contextPath}/pedidos/eliminados" class="btn btn-secondary btn-sm" style="border-style:dashed;color:#888;border-color:#bbb;">
            <i class="ti ti-trash"></i> Eliminados (30 días)
        </a>
        <c:if test="${totalOcultos > 0}">
            <a href="${pageContext.request.contextPath}/pedidos/ocultos"
               class="btn btn-secondary btn-sm" style="border-style:dashed; color:#f57c00; border-color:#f57c00;">
                <i class="ti ti-eye-off"></i> ${totalOcultos} oculto${totalOcultos > 1 ? 's' : ''}
            </a>
        </c:if>
        <div style="margin-left:auto;">
            <a href="${pageContext.request.contextPath}/pedidos/nuevo" class="btn btn-primary btn-sm">
                <i class="ti ti-plus"></i> Nuevo pedido
            </a>
        </div>
    </div>

    <div class="card">
        <div style="overflow-x:auto;">
        <table class="tabla">
            <thead>
                <tr>
                    <th>ID</th><th>Foto</th><th>Cliente</th><th>Descripción</th>
                    <th>Cant.</th><th>Total (Q)</th><th>Anticipo (Q)</th><th>Restante (Q)</th>
                    <th>Entrega</th><th>Estado</th><th>Acciones</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty pedidos}">
                    <tr><td colspan="11" style="text-align:center;color:#aaa;padding:40px;">No hay pedidos registrados</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${pedidos}">
                    <c:if test="${!p.oculto}">
                        <tr>
                            <td><strong>#${p.idPedido}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.tieneFoto()}">
                                        <img src="${pageContext.request.contextPath}/foto/pedido/${p.idPedido}"
                                             style="width:40px;height:40px;border-radius:6px;object-fit:cover;border:1px solid #e0e0e0;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:40px;height:40px;border-radius:6px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#ccc;">
                                            <i class="ti ti-photo" style="font-size:18px;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${p.clienteNombre}</td>
                            <td>${p.descripcion}</td>
                            <td>${p.cantidad}</td>
                            <td>${p.total}</td>
                            <td>${p.anticipo}</td>
                            <td style="font-weight:600;color:${p.restante > 0 ? '#e53935' : '#2e7d32'};">${p.restante}</td>
                            <td>${p.fechaEntrega}</td>
                            <td><span class="badge badge-${p.estadoClase}">${p.estadoEtiqueta}</span></td>
                            <td style="display:flex;gap:4px;align-items:center;">
                                <a href="${pageContext.request.contextPath}/pedidos/detalle?id=${p.idPedido}" class="btn btn-secondary btn-sm" title="Ver detalle">
                                    <i class="ti ti-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/pedidos/editar?id=${p.idPedido}" class="btn btn-secondary btn-sm" title="Editar">
                                    <i class="ti ti-edit"></i>
                                </a>
                                <c:if test="${p.estado == 'ENTREGADO'}">
                                    <a href="${pageContext.request.contextPath}/pedidos/ocultar?id=${p.idPedido}"
                                       class="btn btn-secondary btn-sm" title="Ocultar"
                                       onclick="return confirm('¿Ocultar este pedido? Podrás verlo desde el contador de ocultos.')">
                                        <i class="ti ti-eye-off" style="color:#f57c00;"></i>
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/pedidos/eliminar?id=${p.idPedido}"
                                   class="btn btn-secondary btn-sm" title="Eliminar"
                                   onclick="return confirm('¿Eliminar definitivamente este pedido? Esta acción no se puede deshacer.')">
                                    <i class="ti ti-trash" style="color:#e53935;"></i>
                                </a>
                            </td>
                        </tr>
                    </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
        </div>
    </div>
</c:otherwise>
</c:choose>

<%@ include file="../includes/footer.jsp" %>
