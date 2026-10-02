<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Mi Perfil" scope="request"/>
<%@ include file="includes/header.jsp" %>

<%
    com.bordados.model.Usuario usuarioPerfil = (com.bordados.model.Usuario) session.getAttribute("usuario");
%>

<div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; max-width:900px;">

    <!-- FOTO DE PERFIL -->
    <div class="card">
        <div class="card-header"><span class="card-title"><i class="ti ti-camera"></i> Foto de perfil</span></div>
        <div class="card-body" style="text-align:center;">

            <c:if test="${not empty exito}">
                <div class="alert alert-success"><i class="ti ti-check"></i> ${exito}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="ti ti-alert-circle"></i> ${error}</div>
            </c:if>

            <div style="position:relative; display:inline-block; margin-bottom:16px;">
                <% if (usuarioPerfil.tieneFoto()) { %>
                    <img id="fotoPreview" src="${pageContext.request.contextPath}/foto/usuario/<%= usuarioPerfil.getIdUsuario() %>"
                         style="width:120px;height:120px;border-radius:50%;object-fit:cover;border:3px solid #1976D2;">
                <% } else { %>
                    <div id="fotoPreview" style="width:120px;height:120px;border-radius:50%;background:#1976D2;display:flex;align-items:center;justify-content:center;color:#fff;font-size:48px;font-weight:600;margin:0 auto;">
                        <%= usuarioPerfil.getNombre().charAt(0) %>
                    </div>
                <% } %>
                <label for="inputFoto" style="position:absolute;bottom:4px;right:4px;background:#1976D2;color:#fff;border-radius:50%;width:32px;height:32px;display:flex;align-items:center;justify-content:center;cursor:pointer;box-shadow:0 2px 6px rgba(0,0,0,0.3);">
                    <i class="ti ti-camera" style="font-size:16px;"></i>
                </label>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/perfil/subir-foto" enctype="multipart/form-data" id="formFoto">
                <input type="file" id="inputFoto" name="foto" accept="image/*" style="display:none;" onchange="previewAndUpload(this)">
            </form>

            <div style="font-size:12px;color:#aaa;">Haz clic en el ícono de cámara para cambiar tu foto</div>
            <div style="font-size:11px;color:#ccc;margin-top:4px;">Máximo 2MB — JPG, PNG, GIF</div>
        </div>
    </div>

    <!-- INFO DEL USUARIO -->
    <div class="card">
        <div class="card-header"><span class="card-title"><i class="ti ti-user"></i> Información</span></div>
        <div class="card-body">
            <table style="width:100%;font-size:13px;border-collapse:collapse;">
                <tr>
                    <td style="padding:10px;color:#888;border-bottom:1px solid #f0f0f0;width:40%;">Nombre</td>
                    <td style="padding:10px;font-weight:500;border-bottom:1px solid #f0f0f0;"><%= usuarioPerfil.getNombre() %></td>
                </tr>
                <tr>
                    <td style="padding:10px;color:#888;border-bottom:1px solid #f0f0f0;">Correo</td>
                    <td style="padding:10px;border-bottom:1px solid #f0f0f0;"><%= usuarioPerfil.getCorreo() %></td>
                </tr>
                <tr>
                    <td style="padding:10px;color:#888;">Rol</td>
                    <td style="padding:10px;"><span class="badge badge-blue"><%= usuarioPerfil.getRol() %></span></td>
                </tr>
            </table>
        </div>
    </div>

    <!-- CAMBIAR CONTRASEÑA -->
    <div class="card" style="grid-column:1/-1;">
        <div class="card-header"><span class="card-title"><i class="ti ti-lock"></i> Cambiar contraseña</span></div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/perfil/cambiar-contrasena" style="max-width:500px;">
                <div class="form-group">
                    <label class="form-label">Contraseña actual *</label>
                    <input type="password" name="contrasenaActual" class="form-control" required placeholder="Tu contraseña actual">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Nueva contraseña *</label>
                        <input type="password" name="contrasenaNueva" class="form-control" required minlength="6" id="nuevaPass" placeholder="Mínimo 6 caracteres">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Confirmar *</label>
                        <input type="password" name="confirmarContrasena" class="form-control" required id="confirmarPass" placeholder="Repite la contraseña">
                        <small id="mensajeMatch" style="font-size:11px;margin-top:4px;display:block;"></small>
                    </div>
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">Cancelar</a>
                    <button type="submit" class="btn btn-primary" id="btnGuardar">
                        <i class="ti ti-lock-check"></i> Guardar contraseña
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function previewAndUpload(input) {
    if (input.files && input.files[0]) {
        const file = input.files[0];
        if (file.size > 2 * 1024 * 1024) {
            alert('La imagen es muy grande. Máximo 2MB.');
            return;
        }
        const reader = new FileReader();
        reader.onload = function(e) {
            const preview = document.getElementById('fotoPreview');
            if (preview.tagName === 'IMG') {
                preview.src = e.target.result;
            } else {
                const img = document.createElement('img');
                img.id = 'fotoPreview';
                img.src = e.target.result;
                img.style.cssText = 'width:120px;height:120px;border-radius:50%;object-fit:cover;border:3px solid #1976D2;';
                preview.replaceWith(img);
            }
        };
        reader.readAsDataURL(file);
        document.getElementById('formFoto').submit();
    }
}

const nuevaPass     = document.getElementById('nuevaPass');
const confirmarPass = document.getElementById('confirmarPass');
const mensaje       = document.getElementById('mensajeMatch');
const btnGuardar    = document.getElementById('btnGuardar');

function verificar() {
    if (!confirmarPass.value) { mensaje.textContent = ''; return; }
    if (nuevaPass.value === confirmarPass.value) {
        mensaje.textContent = '✅ Las contraseñas coinciden';
        mensaje.style.color = '#2e7d32';
        btnGuardar.disabled = false;
    } else {
        mensaje.textContent = '❌ Las contraseñas no coinciden';
        mensaje.style.color = '#c62828';
        btnGuardar.disabled = true;
    }
}
nuevaPass.addEventListener('input', verificar);
confirmarPass.addEventListener('input', verificar);
</script>

<%@ include file="includes/footer.jsp" %>
