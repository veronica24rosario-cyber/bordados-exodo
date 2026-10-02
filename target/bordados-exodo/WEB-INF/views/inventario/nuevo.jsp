<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Nuevo Material" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:600px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-package-plus"></i> Registrar nuevo material</span>
    </div>
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/inventario/guardar">
            <div class="form-group">
                <label class="form-label">Nombre del material *</label>
                <input type="text" name="nombreMaterial" class="form-control" required placeholder="Ej: Hilo blanco">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Existencias actuales *</label>
                    <input type="number" name="existencias" class="form-control" min="0" step="0.01" required placeholder="0">
                </div>
                <div class="form-group">
                    <label class="form-label">Stock mínimo *</label>
                    <input type="number" name="stockMinimo" class="form-control" min="0" step="0.01" required placeholder="0">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Unidad de medida *</label>
                    <select name="unidad" class="form-control" required>
                        <option value="">Seleccionar...</option>
                        <option value="Carrete">Carrete</option>
                        <option value="Metro">Metro</option>
                        <option value="Unidad">Unidad</option>
                        <option value="Litro">Litro</option>
                        <option value="Kilo">Kilo</option>
                        <option value="Caja">Caja</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Consumo mensual estimado</label>
                    <input type="number" name="consumoMensual" class="form-control" min="0" step="0.01" value="0">
                </div>
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/inventario" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Guardar material
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
