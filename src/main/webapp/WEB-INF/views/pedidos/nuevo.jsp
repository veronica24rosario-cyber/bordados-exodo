<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Nuevo Pedido" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:860px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-clipboard-plus"></i> Registrar nuevo pedido</span>
    </div>
    <div class="card-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${error}</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/pedidos/guardar">

            <!-- Fila 1: Cliente y Cantidad -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Cliente *</label>
                    <select name="idCliente" class="form-control" required>
                        <option value="">Seleccionar cliente...</option>
                        <c:forEach var="c" items="${clientes}">
                            <option value="${c.idCliente}">${c.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Cantidad *</label>
                    <input type="number" name="cantidad" class="form-control" min="1" required placeholder="Ej: 100">
                </div>
            </div>

            <!-- Descripción -->
            <div class="form-group">
                <label class="form-label">Descripción del pedido *</label>
                <input type="text" name="descripcion" class="form-control" required placeholder="Ej: 100 uniformes bordados con logo institucional">
            </div>

            <!-- Fila 2: Diseño y Estado -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Diseño / Referencia</label>
                    <input type="text" name="diseno" class="form-control" placeholder="Código o nombre del diseño">
                </div>
                <div class="form-group">
                    <label class="form-label">Estado inicial</label>
                    <select name="estado" class="form-control">
                        <option value="RECIBIDO">Recibido</option>
                        <option value="EN_PROCESO">En proceso</option>
                    </select>
                </div>
            </div>

            <!-- Fila 3: Fechas -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Fecha de recepción *</label>
                    <input type="date" name="fechaRecepcion" class="form-control" required value="<%= java.time.LocalDate.now() %>">
                </div>
                <div class="form-group">
                    <label class="form-label">Fecha de entrega prometida *</label>
                    <input type="date" name="fechaEntrega" class="form-control" required>
                    <small style="color:#888;font-size:11px;margin-top:4px;display:block;">Se generarán alertas automáticas 3 días y 1 día antes.</small>
                </div>
            </div>

            <!-- Fila 4: Pagos -->
            <div style="background:#f8f9fa;border:1px solid #e8e8e8;border-radius:8px;padding:16px;margin-bottom:16px;">
                <div style="font-size:13px;font-weight:600;color:#333;margin-bottom:12px;">
                    Información de pago
                </div>
                <div class="form-row-3">
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Total del pedido (Q)</label>
                        <input type="number" name="total" class="form-control" min="0" step="0.01" placeholder="0.00"
                               id="totalInput" oninput="calcularRestante()">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Anticipo recibido (Q)</label>
                        <input type="number" name="anticipo" class="form-control" min="0" step="0.01" placeholder="0.00"
                               id="anticipoInput" oninput="calcularRestante()">
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label">Restante por cobrar (Q)</label>
                        <input type="text" id="restanteInput" class="form-control"
                               style="background:#f0f0f0;font-weight:600;color:#e53935;" readonly value="0.00">
                    </div>
                </div>
            </div>

            <!-- Notas -->
            <div class="form-group">
                <label class="form-label">Notas adicionales</label>
                <textarea name="notas" class="form-control" rows="3" placeholder="Ej: Tallas S, M, L — colores específicos, medidas especiales, instrucciones del cliente..."></textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Guardar pedido
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
</script>

<%@ include file="../includes/footer.jsp" %>
