<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Editar Material" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;max-width:900px;">

    <!-- DATOS DEL MATERIAL -->
    <div class="card">
        <div class="card-header"><span class="card-title"><i class="ti ti-package"></i> Editar material</span></div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/inventario/actualizar">
                <input type="hidden" name="idMaterial" value="${material.idMaterial}">
                <div class="form-group">
                    <label class="form-label">Nombre del material *</label>
                    <input type="text" name="nombreMaterial" class="form-control" required value="${material.nombreMaterial}">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Stock mínimo *</label>
                        <input type="number" name="stockMinimo" class="form-control" min="0" step="0.01" required value="${material.stockMinimo}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Unidad *</label>
                        <select name="unidad" class="form-control" required>
                            <option value="Carrete" ${material.unidad=='Carrete'?'selected':''}>Carrete</option>
                            <option value="Metro" ${material.unidad=='Metro'?'selected':''}>Metro</option>
                            <option value="Unidad" ${material.unidad=='Unidad'?'selected':''}>Unidad</option>
                            <option value="Litro" ${material.unidad=='Litro'?'selected':''}>Litro</option>
                            <option value="Kilo" ${material.unidad=='Kilo'?'selected':''}>Kilo</option>
                            <option value="Caja" ${material.unidad=='Caja'?'selected':''}>Caja</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Consumo mensual estimado</label>
                    <input type="number" name="consumoMensual" class="form-control" min="0" step="0.01" value="${material.consumoMensual}">
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/inventario" class="btn btn-secondary">Cancelar</a>
                    <button type="submit" class="btn btn-primary"><i class="ti ti-check"></i> Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- FOTO DEL MATERIAL -->
    <div class="card">
        <div class="card-header"><span class="card-title"><i class="ti ti-photo"></i> Foto del material</span></div>
        <div class="card-body" style="text-align:center;">
            <c:choose>
                <c:when test="${material.tieneFoto()}">
                    <img src="${pageContext.request.contextPath}/foto/material/${material.idMaterial}"
                         style="max-width:100%;max-height:220px;border-radius:8px;object-fit:contain;border:1px solid #e0e0e0;margin-bottom:14px;">
                </c:when>
                <c:otherwise>
                    <div style="width:100%;height:160px;border-radius:8px;background:#f8f9fa;border:2px dashed #e0e0e0;display:flex;flex-direction:column;align-items:center;justify-content:center;color:#ccc;margin-bottom:14px;">
                        <i class="ti ti-package" style="font-size:40px;"></i>
                        <div style="font-size:12px;margin-top:8px;">Sin foto</div>
                    </div>
                </c:otherwise>
            </c:choose>
            <form method="post" action="${pageContext.request.contextPath}/inventario/guardar-foto" enctype="multipart/form-data">
                <input type="hidden" name="idMaterial" value="${material.idMaterial}">
                <label style="display:inline-flex;align-items:center;gap:6px;background:#f5f5f5;border:1px solid #e0e0e0;border-radius:6px;padding:7px 14px;cursor:pointer;font-size:13px;color:#555;">
                    <i class="ti ti-camera"></i>
                    ${material.tieneFoto() ? 'Cambiar foto' : 'Subir foto'}
                    <input type="file" name="foto" accept="image/*" style="display:none;" onchange="this.closest('form').submit()">
                </label>
                <div style="font-size:11px;color:#aaa;margin-top:8px;">Máximo 5MB — JPG, PNG, GIF</div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
