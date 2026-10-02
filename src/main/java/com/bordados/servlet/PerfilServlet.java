package com.bordados.servlet;

import com.bordados.dao.UsuarioDAO;
import com.bordados.model.Usuario;
import com.bordados.util.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.*;

@WebServlet("/perfil/*")
@MultipartConfig(maxFileSize = 20 * 1024 * 1024) // 2MB max
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        if ("/subir-foto".equals(path)) {
            Usuario usuario = (Usuario) req.getSession().getAttribute("usuario");
            try {
                Part filePart = req.getPart("foto");
                if (filePart != null && filePart.getSize() > 0) {
                    byte[] fotoBytes = filePart.getInputStream().readAllBytes();
                    String mimeType  = filePart.getContentType();

                    String sql = "UPDATE usuarios SET foto=?, foto_tipo=? WHERE id_usuario=?";
                    try (Connection conn = ConexionDB.obtenerConexion();
                         PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setBytes(1, fotoBytes);
                        ps.setString(2, mimeType);
                        ps.setInt(3, usuario.getIdUsuario());
                        ps.executeUpdate();
                    }
                    usuario.setFoto(fotoBytes);
                    usuario.setFotoTipo(mimeType);
                    req.getSession().setAttribute("usuario", usuario);
                    req.setAttribute("exito", "Foto de perfil actualizada exitosamente.");
                } else {
                    req.setAttribute("error", "Por favor selecciona una imagen válida.");
                }
            } catch (Exception e) {
                req.setAttribute("error", "Error al subir la foto: " + e.getMessage());
            }
            req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
            return;
        }

        if ("/cambiar-contrasena".equals(path)) {
            Usuario usuario = (Usuario) req.getSession().getAttribute("usuario");
            String contrasenaActual   = req.getParameter("contrasenaActual");
            String contrasenaNueva    = req.getParameter("contrasenaNueva");
            String confirmarContrasena = req.getParameter("confirmarContrasena");

            // Validar que las nuevas contraseñas coincidan
            if (!contrasenaNueva.equals(confirmarContrasena)) {
                req.setAttribute("error", "Las contraseñas nuevas no coinciden.");
                req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
                return;
            }

            // Validar longitud mínima
            if (contrasenaNueva.length() < 6) {
                req.setAttribute("error", "La nueva contraseña debe tener al menos 6 caracteres.");
                req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
                return;
            }

            // Verificar contraseña actual
            if (!BCrypt.checkpw(contrasenaActual, usuario.getContrasena())) {
                req.setAttribute("error", "La contraseña actual es incorrecta.");
                req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
                return;
            }

            // Cambiar contraseña
            UsuarioDAO dao = new UsuarioDAO();
            boolean ok = dao.cambiarContrasena(usuario.getIdUsuario(), contrasenaNueva);

            if (ok) {
                // Actualizar la contraseña en la sesión
                usuario.setContrasena(BCrypt.hashpw(contrasenaNueva, BCrypt.gensalt(10)));
                req.getSession().setAttribute("usuario", usuario);
                req.setAttribute("exito", "Contraseña actualizada exitosamente.");
            } else {
                req.setAttribute("error", "No se pudo actualizar la contraseña. Intenta de nuevo.");
            }

            req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
        }
    }

    private boolean estaAutenticado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("usuario") != null;
    }
}
