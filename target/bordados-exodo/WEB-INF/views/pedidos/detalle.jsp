<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Detalle de Pedido" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<c:if test="${not empty exito}">
    <div class="alert alert-success"><i class="ti ti-check"></i> ${exito}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${error}</div>
</c:if>

<div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; max-width:1000px;">

    <!-- INFO DEL PEDIDO -->
    <div class="card">
        <div class="card-header">
            <span class="card-title"><i class="ti ti-clipboard-text"></i> Pedido #${pedido.idPedido}</span>
            <span class="badge badge-${pedido.estadoClase}">${pedido.estadoEtiqueta}</span>
        </div>
        <div class="card-body">
            <table style="width:100%; font-size:13px; border-collapse:collapse;">
                <tr><td style="padding:9px;color:#888;border-bottom:1px solid #f0f0f0;width:40%;">Cliente</td>
                    <td style="padding:9px;font-weight:500;border-bottom:1px solid #f0f0f0;">${pedido.clienteNombre}</td></tr>
                <tr><td style="padding:9px;color:#888;border-bottom:1px solid #f0f0f0;">Descripción</td>
                    <td style="padding:9px;border-bottom:1px solid #f0f0f0;">${pedido.descripcion}</td></tr>
                <tr><td style="padding:9px;color:#888;border-bottom:1px solid #f0f0f0;">Cantidad</td>
                    <td style="padding:9px;border-bottom:1px solid #f0f0f0;">${pedido.cantidad}</td></tr>
                <tr><td style="padding:9px;color:#888;border-bottom:1px solid #f0f0f0;">Diseño</td>
                    <td style="padding:9px;border-bottom:1px solid #f0f0f0;">${pedido.diseno}</td></tr>
                <tr><td style="padding:9px;color:#888;border-bottom:1px solid #f0f0f0;">Fecha recepción</td>
                    <td style="padding:9px;border-bottom:1px solid #f0f0f0;">${pedido.fechaRecepcion}</td></tr>
                <tr><td style="padding:9px;color:#888;border-bottom:1px solid #f0f0f0;">Fecha entrega</td>
                    <td style="padding:9px;border-bottom:1px solid #f0f0f0;">${pedido.fechaEntrega}</td></tr>
                <tr><td style="padding:9px;color:#888;">Notas</td>
                    <td style="padding:9px;"><c:out value="${pedido.notas}" default="—"/></td></tr>
            </table>
            <div style="margin-top:16px; display:flex; gap:8px; flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary btn-sm">
                    <i class="ti ti-arrow-left"></i> Volver
                </a>
                <a href="${pageContext.request.contextPath}/pedidos/editar?id=${pedido.idPedido}" class="btn btn-primary btn-sm">
                    <i class="ti ti-edit"></i> Editar
                </a>
                <a href="${pageContext.request.contextPath}/pedidos/eliminar?id=${pedido.idPedido}"
                   class="btn btn-secondary btn-sm"
                   onclick="return confirm('¿Eliminar este pedido? Esta acción no se puede deshacer.')">
                    <i class="ti ti-trash" style="color:#e53935;"></i> Eliminar
                </a>
            </div>
        </div>
    </div>

    <!-- INFORMACIÓN DE PAGO -->
    <div class="card">
        <div class="card-header">
            <span class="card-title">Información de pago</span>
        </div>
        <div class="card-body">
            <div style="display:grid;grid-template-columns:1fr;gap:12px;">
                <div style="background:#e8f5e9;border:1px solid #a5d6a7;border-radius:8px;padding:16px;text-align:center;">
                    <div style="font-size:12px;color:#2e7d32;margin-bottom:4px;">Total del pedido</div>
                    <div style="font-size:26px;font-weight:700;color:#1b5e20;">Q ${pedido.total}</div>
                </div>
                <div style="background:#e3f2fd;border:1px solid #90caf9;border-radius:8px;padding:16px;text-align:center;">
                    <div style="font-size:12px;color:#1565c0;margin-bottom:4px;">Anticipo recibido</div>
                    <div style="font-size:26px;font-weight:700;color:#0d47a1;">Q ${pedido.anticipo}</div>
                </div>
                <div style="background:${pedido.restante > 0 ? '#fff5f5' : '#e8f5e9'};border:1px solid ${pedido.restante > 0 ? '#ffcdd2' : '#a5d6a7'};border-radius:8px;padding:16px;text-align:center;">
                    <div style="font-size:12px;color:${pedido.restante > 0 ? '#c62828' : '#2e7d32'};margin-bottom:4px;">Restante por cobrar</div>
                    <div style="font-size:26px;font-weight:700;color:${pedido.restante > 0 ? '#b71c1c' : '#1b5e20'};">Q ${pedido.restante}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- FOTO DE REFERENCIA -->
    <div class="card" style="grid-column:1/-1;">
        <div class="card-header">
            <span class="card-title"><i class="ti ti-photo"></i> Foto de referencia del diseño</span>
        </div>
        <div class="card-body">
            <div style="display:grid;grid-template-columns:${pedido.tieneFoto() ? '1fr 1fr' : '1fr'};gap:20px;align-items:start;">

                <!-- Foto actual -->
                <c:if test="${pedido.tieneFoto()}">
                    <div style="text-align:center;">
                        <img src="${pageContext.request.contextPath}/foto/pedido/${pedido.idPedido}"
                             style="max-width:100%;max-height:300px;border-radius:8px;object-fit:contain;border:1px solid #e0e0e0;">
                    </div>
                </c:if>

                <!-- Zona de subir / arrastrar -->
                <div>
                    <form id="formFoto" method="post"
                          action="${pageContext.request.contextPath}/pedidos/guardar-foto"
                          enctype="multipart/form-data">
                        <input type="hidden" name="idPedido" value="${pedido.idPedido}">
                        <input type="file" id="inputFoto" name="fotoReferencia" accept="image/*" style="display:none;"
                               onchange="document.getElementById('formFoto').submit()">

                        <!-- Zona de arrastre -->
                        <div id="dropZone"
                             onclick="document.getElementById('inputFoto').click()"
                             ondragover="event.preventDefault(); this.style.borderColor='#1976D2'; this.style.background='#e3f2fd';"
                             ondragleave="this.style.borderColor='#e0e0e0'; this.style.background='#f8f9fa';"
                             ondrop="handleDrop(event)"
                             style="width:100%;min-height:180px;border-radius:8px;background:#f8f9fa;border:2px dashed #e0e0e0;display:flex;flex-direction:column;align-items:center;justify-content:center;color:#aaa;cursor:pointer;transition:all 0.2s;padding:20px;text-align:center;">
                            <i class="ti ti-cloud-upload" style="font-size:48px;margin-bottom:10px;"></i>
                            <div style="font-size:14px;font-weight:500;color:#666;">
                                ${pedido.tieneFoto() ? 'Cambiar foto de referencia' : 'Subir foto de referencia'}
                            </div>
                            <div style="font-size:12px;margin-top:6px;">
                                Haz clic aquí o arrastra una imagen
                            </div>
                            <div style="font-size:11px;color:#ccc;margin-top:4px;">
                                JPG, PNG, GIF, WEBP — cualquier tamaño
                            </div>
                        </div>

                        <!-- Preview antes de subir -->
                        <div id="previewContainer" style="display:none;margin-top:12px;text-align:center;">
                            <img id="previewImg" style="max-width:100%;max-height:200px;border-radius:8px;border:1px solid #e0e0e0;">
                            <div style="margin-top:8px;display:flex;gap:8px;justify-content:center;">
                                <button type="submit" class="btn btn-primary btn-sm">
                                    <i class="ti ti-upload"></i> Subir foto
                                </button>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="cancelarFoto()">
                                    Cancelar
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function handleDrop(event) {
    event.preventDefault();
    const dropZone = document.getElementById('dropZone');
    dropZone.style.borderColor = '#e0e0e0';
    dropZone.style.background = '#f8f9fa';

    const files = event.dataTransfer.files;
    if (files.length > 0) {
        mostrarPreview(files[0]);
        const dt = new DataTransfer();
        dt.items.add(files[0]);
        document.getElementById('inputFoto').files = dt.files;
    }
}

document.getElementById('inputFoto').addEventListener('change', function() {
    if (this.files && this.files[0]) {
        mostrarPreview(this.files[0]);
    }
});

function mostrarPreview(file) {
    const reader = new FileReader();
    reader.onload = function(e) {
        document.getElementById('previewImg').src = e.target.result;
        document.getElementById('previewContainer').style.display = 'block';
        document.getElementById('dropZone').style.display = 'none';
    };
    reader.readAsDataURL(file);
}

function cancelarFoto() {
    document.getElementById('previewContainer').style.display = 'none';
    document.getElementById('dropZone').style.display = 'flex';
    document.getElementById('inputFoto').value = '';
}
</script>

<%@ include file="../includes/footer.jsp" %>
