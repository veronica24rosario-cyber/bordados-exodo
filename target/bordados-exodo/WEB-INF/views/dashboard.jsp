<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<%@ include file="includes/header.jsp" %>

<!-- ALERTAS ACTIVAS -->
<c:if test="${not empty alertas}">
    <div style="margin-bottom:20px;">
        <c:forEach var="alerta" items="${alertas}">
            <div class="alert alert-${alerta.clase}" style="justify-content:space-between;">
                <div style="display:flex;align-items:center;gap:10px;">
                    <i class="ti ${alerta.icono}"></i>
                    <span>${alerta.mensaje}</span>
                </div>
                <a href="${pageContext.request.contextPath}/alertas/marcar-leida?id=${alerta.idAlerta}"
                   style="font-size:11px;color:inherit;opacity:0.7;text-decoration:none;white-space:nowrap;margin-left:12px;">
                    Marcar leída ✕
                </a>
            </div>
        </c:forEach>
    </div>
</c:if>

<!-- ESTADÍSTICAS -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-label"><i class="ti ti-clipboard-list"></i> Pedidos activos</div>
        <div class="stat-value">${pedidosActivos}</div>
        <div class="stat-sub">Órdenes en proceso</div>
    </div>
    <div class="stat-card success">
        <div class="stat-label"><i class="ti ti-truck-delivery"></i> Entregados este mes</div>
        <div class="stat-value">${entregadosMes}</div>
        <div class="stat-sub">Pedidos completados</div>
    </div>
    <div class="stat-card ${stockBajo > 0 ? 'danger' : 'success'}">
        <div class="stat-label"><i class="ti ti-package"></i> Stock bajo</div>
        <div class="stat-value">${stockBajo}</div>
        <div class="stat-sub">${stockBajo > 0 ? 'Requieren compra' : 'Todo en orden'}</div>
    </div>
    <div class="stat-card">
        <div class="stat-label"><i class="ti ti-users"></i> Clientes</div>
        <div class="stat-value">${totalClientes}</div>
        <div class="stat-sub">Registrados</div>
    </div>
</div>

<!-- ACCESOS RÁPIDOS -->
<div style="display:flex;gap:10px;margin-bottom:20px;flex-wrap:wrap;">
    <a href="${pageContext.request.contextPath}/pedidos/nuevo" class="btn btn-primary">
        <i class="ti ti-clipboard-plus"></i> Nuevo pedido
    </a>
    <a href="${pageContext.request.contextPath}/clientes/nuevo" class="btn btn-secondary">
        <i class="ti ti-user-plus"></i> Nuevo cliente
    </a>
    <a href="${pageContext.request.contextPath}/inventario/nuevo" class="btn btn-secondary">
        <i class="ti ti-package-plus"></i> Nuevo material
    </a>
    <a href="${pageContext.request.contextPath}/inventario" class="btn btn-secondary">
        <i class="ti ti-transfer"></i> Registrar consumo
    </a>
</div>

<!-- TABLA DE PEDIDOS ACTIVOS -->
<div class="card">
    <div class="card-header">
        <span class="card-title">Pedidos activos</span>
        <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary btn-sm">Ver todos</a>
    </div>
    <table class="tabla">
        <thead>
            <tr><th>ID</th><th>Foto</th><th>Cliente</th><th>Descripción</th><th>Cantidad</th><th>Entrega</th><th>Estado</th><th>Acciones</th></tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty pedidosRecientes}">
                <tr><td colspan="8" style="text-align:center;color:#aaa;padding:30px;">No hay pedidos activos</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="p" items="${pedidosRecientes}">
                    <tr>
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
                        <td>${p.fechaEntrega}</td>
                        <td><span class="badge badge-${p.estadoClase}">${p.estadoEtiqueta}</span></td>
                        <td style="display:flex;gap:4px;">
                            <a href="${pageContext.request.contextPath}/pedidos/detalle?id=${p.idPedido}" class="btn btn-secondary btn-sm">
                                <i class="ti ti-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/pedidos/editar?id=${p.idPedido}" class="btn btn-secondary btn-sm">
                                <i class="ti ti-edit"></i>
                            </a>
                            <c:if test="${p.estado == 'ENTREGADO'}">
                                <a href="${pageContext.request.contextPath}/pedidos/ocultar?id=${p.idPedido}"
                                   class="btn btn-secondary btn-sm" title="Ocultar"
                                   onclick="return confirm('¿Ocultar este pedido del dashboard?')">
                                    <i class="ti ti-eye-off" style="color:#f57c00;"></i>
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

<%@ include file="includes/footer.jsp" %>
