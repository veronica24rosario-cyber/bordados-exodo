package com.bordados.servlet;

import com.bordados.dao.ConfiguracionDAO;
import com.bordados.model.Usuario;
import com.bordados.util.CorreoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/configuracion/*")
public class ConfiguracionServlet extends HttpServlet {

    private final ConfiguracionDAO dao = new ConfiguracionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!esAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/dashboard"); return; }

        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        if ("/probar-correo".equals(path)) {
            CorreoUtil.enviarAlerta(
                "✅ Prueba de configuración — Bordados Éxodo",
                "<h2>Correo de prueba</h2><p>Si recibes este mensaje, las notificaciones están configuradas correctamente.</p>"
            );
            req.setAttribute("exito", "Correo de prueba enviado. Revisa tu bandeja de entrada.");
        }

        req.setAttribute("config", dao.obtenerTodas());
        req.getRequestDispatcher("/WEB-INF/views/configuracion.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!esAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/dashboard"); return; }

        String correoOrigen  = req.getParameter("correo_origen");
        String password      = req.getParameter("correo_password");
        String correoDestino = req.getParameter("correo_destino");
        String notifActivas  = req.getParameter("notificaciones_activas") != null ? "true" : "false";

        dao.guardar("correo_origen",          correoOrigen != null ? correoOrigen : "");
        dao.guardar("correo_destino",         correoDestino != null ? correoDestino : "");
        dao.guardar("notificaciones_activas", notifActivas);

        // Solo actualizar password si se ingresó uno nuevo
        if (password != null && !password.trim().isEmpty()) {
            dao.guardar("correo_password", password.trim());
        }

        req.setAttribute("exito", "Configuración guardada exitosamente.");
        req.setAttribute("config", dao.obtenerTodas());
        req.getRequestDispatcher("/WEB-INF/views/configuracion.jsp").forward(req, resp);
    }

    private boolean esAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Usuario u = (Usuario) s.getAttribute("usuario");
        return u != null && u.esAdministrador();
    }
}
