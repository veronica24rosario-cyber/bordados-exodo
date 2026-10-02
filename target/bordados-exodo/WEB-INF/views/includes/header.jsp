<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.bordados.model.Usuario u = (com.bordados.model.Usuario) session.getAttribute("usuario");
    if (u == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String uri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} — Bordados Éxodo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@2.44.0/tabler-icons.min.css">
</head>
<body>
<div class="layout">
    <!-- SIDEBAR -->
    <nav class="sidebar">
        <div class="sidebar-logo">
            <div class="nombre"><i class="ti ti-needle-thread"></i> Bordados Éxodo</div>
            <div class="sub">Sistema de gestión</div>
        </div>

        <div class="nav-section">Principal</div>
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item <%= uri.contains("/dashboard") ? "active" : "" %>">
            <i class="ti ti-layout-dashboard"></i> Dashboard
        </a>

        <div class="nav-section">Operaciones</div>
        <a href="${pageContext.request.contextPath}/pedidos" class="nav-item <%= uri.contains("/pedidos") ? "active" : "" %>">
            <i class="ti ti-clipboard-list"></i> Pedidos
        </a>
        <a href="${pageContext.request.contextPath}/inventario" class="nav-item <%= uri.contains("/inventario") ? "active" : "" %>">
            <i class="ti ti-box"></i> Inventario
        </a>
        <a href="${pageContext.request.contextPath}/clientes" class="nav-item <%= uri.contains("/clientes") ? "active" : "" %>">
            <i class="ti ti-users"></i> Clientes
        </a>

        <div class="nav-section">Administración</div>
        <% if (u.esAdministrador()) { %>
        <a href="${pageContext.request.contextPath}/usuarios" class="nav-item <%= uri.contains("/usuarios") ? "active" : "" %>">
            <i class="ti ti-user-cog"></i> Usuarios
        </a>
        <% } %>

        <% if (u.esAdministrador()) { %>
        <a href="${pageContext.request.contextPath}/configuracion"
           class="nav-item ${pageContext.request.requestURI.contains('/configuracion') ? 'active' : ''}">
            <i class="ti ti-settings"></i> Configuración
        </a>
        <% } %>
        <div class="sidebar-footer">
            <div class="usuario">
                <strong><%= u.getNombre() %></strong>
                <%= u.getRol() %>
            </div>
            <a href="${pageContext.request.contextPath}/perfil" class="btn btn-secondary btn-sm" style="width:100%; justify-content:center; margin-bottom:6px;">
                <i class="ti ti-user-circle"></i> Mi perfil
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary btn-sm" style="width:100%; justify-content:center;">
                <i class="ti ti-logout"></i> Cerrar sesión
            </a>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">${pageTitle}</div>
            <div style="display:flex; align-items:center; gap:16px;">
                <c:if test="${alertasNoLeidas > 0}">
                <div class="alert-badge" onclick="location.href='${pageContext.request.contextPath}/dashboard'">
                    <i class="ti ti-bell"></i>
                    <span class="count">${alertasNoLeidas}</span>
                </div>
                </c:if>
                <div style="font-size:13px; color:#666;"><%= u.getNombre() %></div>
            </div>
        </div>
        <div class="page-body">
