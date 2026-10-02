<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Nuevo Cliente" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="card" style="max-width:600px;">
    <div class="card-header">
        <span class="card-title"><i class="ti ti-user-plus"></i> Registrar nuevo cliente</span>
    </div>
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/clientes/guardar">
            <div class="form-group">
                <label class="form-label">Nombre *</label>
                <input type="text" name="nombre" class="form-control" required placeholder="Ej: Colegio San José">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Teléfono</label>
                    <input type="text" name="telefono" class="form-control" placeholder="Ej: 2222-3333">
                </div>
                <div class="form-group">
                    <label class="form-label">Correo</label>
                    <input type="email" name="correo" class="form-control" placeholder="correo@ejemplo.com">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Dirección</label>
                <input type="text" name="direccion" class="form-control" placeholder="Zona, municipio, departamento">
            </div>
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/clientes" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">
                    <i class="ti ti-check"></i> Guardar cliente
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
