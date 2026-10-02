<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Editar Pedido" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:860px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-clipboard-check"></i> Editar pedido #${pedido.idPedido}</span>
    </div>
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/pedidos/actualizar">
            <input type="hidden" name="idPedido" value="${pedido.idPedido}">

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Cliente *</label>
                    <select name="idCliente" class="form-control" required>
                        <c:forEach var="c" items="${clientes}">
                            <option value="${c.idCliente}" ${c.idCliente == pedido.idCliente ? 'selected' : ''}>${c.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Cantidad *</label>
                    <input type="number" name="cantidad" class="form-control" min="1" required value="${pedido.cantidad}">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Descripción del pedido *</label>
                <input type="text" name="descripcion" class="form-control" required value="${pedido.descripcion}">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Diseño / Referencia</label>
                    <input type="text" name="diseno" class="form-control" value="${pedido.diseno}">
                </div>
                <div class="form-group">
                    <label class="form-label">Estado</label>
                    <select name="estado" class="form-control">
                        <option value="RECIBIDO" ${pedido.estado == 'RECIBIDO' ? 'selected' : ''}>Recibido</option>
                        <option value="EN_PROCESO" ${pedido.estado == 'EN_PROCESO' ? 'selected' : ''}>En proceso</option>
                        <option value="TERMINADO" ${pedido.estado == 'TERMINADO' ? 'selected' : ''}>Terminado</option>
                        <option value="ENTREGADO" ${pedido.estado == 'ENTREGADO' ? 'selected' : ''}>Entregado</option>
                        <option value="CANCELADO" ${pedido.estado == 'CANCELADO' ? 'selected' : ''}>Cancelado</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Fecha de recepción *</label>
                    <input type="date" name="fechaRecepcion" class="form-control" required value="${pedido.fechaRecepcion}">
                </div>
                <div class="form-group">
                    <label class="form-label">Fecha de entrega *</label>
                    <input type="date" name="fechaEntrega" class="form-control" required value="${pedido.fechaEntrega}">
                </div>
            </div>

            <!-- Información de pago -->
            <div style="background:#f8f9fa;border:1px solid #e8e8e8;border-radius:8px;padding:16px;margin-bottom:16px;">
                <div style="font-size:13px;font-weight:600;color:#333;margin-bottom:12px;">
                    Información de pago
                </div>
                <div class="form-row-3">
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Total del pedido (Q)</label>
                        <input type="number" name="total" class="form-control" min="0" step="0.01"
                               value="${pedido.total}" id="totalInput" oninput="calcularRestante()">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Anticipo recibido (Q)</label>
                        <input type="number" name="anticipo" class="form-control" min="0" step="0.01"
                               value="${pedido.anticipo}" id="anticipoInput" oninput="calcularRestante()">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Restante por cobrar (Q)</label>
                        <input type="text" id="restanteInput" class="form-control"
                               style="background:#f0f0f0;font-weight:600;" readonly value="${pedido.restante}">
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Notas adicionales</label>
                <textarea name="notas" class="form-control" rows="3"
                          placeholder="Ej: Tallas S, M, L — colores específicos, medidas especiales, instrucciones del cliente..."><c:out value="${pedido.notas}" default=""/></textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Guardar cambios
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function calcularRestante() {
    const total    = parseFloat(document.getElementById('totalInput').value) || 0;
    const anticipo = parseFloat(document.getElementById('anticipoInput').value) || 0;
    const restante = total - anticipo;
    document.getElementById('restanteInput').value = restante.toFixed(2);
    document.getElementById('restanteInput').style.color = restante > 0 ? '#e53935' : '#2e7d32';
}
calcularRestante();
</script>

<%@ include file="../includes/footer.jsp" %>
