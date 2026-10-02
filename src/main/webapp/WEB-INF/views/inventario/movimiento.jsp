<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Registrar Movimiento" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:600px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-transfer"></i> Registrar movimiento de inventario</span>
    </div>
    <div class="card-body">
        <div class="alert alert-info" style="margin-bottom:16px;">
            <i class="ti ti-info-circle"></i>
            Material: <strong>${material.nombreMaterial}</strong> —
            Existencias actuales: <strong>${material.existencias} ${material.unidad}</strong>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/inventario/registrar-movimiento">
            <input type="hidden" name="idMaterial" value="${material.idMaterial}">

            <div class="form-group">
                <label class="form-label">Tipo de movimiento *</label>
                <select name="tipo" class="form-control" required id="tipoSelect" onchange="actualizarEtiqueta()">
                    <option value="COMPRA">Compra (aumenta existencias)</option>
                    <option value="CONSUMO">Consumo mensual (disminuye existencias)</option>
                    <option value="AJUSTE">Ajuste (establecer cantidad exacta)</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" id="labelCantidad">Cantidad comprada *</label>
                <input type="number" name="cantidad" class="form-control" min="0" step="0.01" required
                       placeholder="Ej: 10">
            </div>

            <div class="form-group">
                <label class="form-label">Descripción / Observaciones</label>
                <textarea name="descripcion" class="form-control" rows="3"
                          placeholder="Proveedor, motivo del ajuste, mes de consumo..."></textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/inventario" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Registrar movimiento
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function actualizarEtiqueta() {
    const tipo = document.getElementById('tipoSelect').value;
    const label = document.getElementById('labelCantidad');
    if (tipo === 'COMPRA')   label.textContent = 'Cantidad comprada *';
    if (tipo === 'CONSUMO')  label.textContent = 'Cantidad consumida en el mes *';
    if (tipo === 'AJUSTE')   label.textContent = 'Nueva cantidad total en existencia *';
}
</script>

<%@ include file="../includes/footer.jsp" %>
