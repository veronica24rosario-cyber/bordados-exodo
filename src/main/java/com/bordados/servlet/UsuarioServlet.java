package com.bordados.servlet;

import com.bordados.dao.UsuarioDAO;
import com.bordados.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/usuarios/*")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!esAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/dashboard"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        switch (path) {
            case "/nuevo" -> req.getRequestDispatcher("/WEB-INF/views/usuarios/nuevo.jsp").forward(req, resp);
            case "/editar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("usuario", dao.obtenerPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/usuarios/editar.jsp").forward(req, resp);
            }
            case "/eliminar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                Usuario usuarioSesion = (Usuario) req.getSession().getAttribute("usuario");
                if (id == usuarioSesion.getIdUsuario()) {
                    req.setAttribute("usuarios", dao.listarTodos());
                    req.setAttribute("errorEliminar", "No puedes eliminar tu propio usuario.");
                    req.getRequestDispatcher("/WEB-INF/views/usuarios/lista.jsp").forward(req, resp);
                    return;
                }
                dao.eliminar(id);
                resp.sendRedirect(req.getContextPath() + "/usuarios?exito=eliminado");
            }
            default -> {
                req.setAttribute("usuarios", dao.listarTodos());
                req.getRequestDispatcher("/WEB-INF/views/usuarios/lista.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!esAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/dashboard"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        switch (path) {
            case "/guardar" -> {
                String contrasena = req.getParameter("contrasena");
                String confirmar  = req.getParameter("confirmar");

                if (!contrasena.equals(confirmar)) {
                    req.setAttribute("error", "Las contraseñas no coinciden.");
                    req.getRequestDispatcher("/WEB-INF/views/usuarios/nuevo.jsp").forward(req, resp);
                    return;
                }

                Usuario u = new Usuario();
                u.setNombre(req.getParameter("nombre"));
                u.setCorreo(req.getParameter("correo"));
                u.setContrasena(contrasena);
                u.setRol(req.getParameter("rol"));

                if (dao.insertar(u)) {
                    resp.sendRedirect(req.getContextPath() + "/usuarios?exito=creado");
                } else {
                    req.setAttribute("error", "No se pudo crear el usuario. El correo puede estar en uso.");
                    req.getRequestDispatcher("/WEB-INF/views/usuarios/nuevo.jsp").forward(req, resp);
                }
            }
            case "/actualizar" -> {
                Usuario u = new Usuario();
                u.setIdUsuario(Integer.parseInt(req.getParameter("idUsuario")));
                u.setNombre(req.getParameter("nombre"));
                u.setCorreo(req.getParameter("correo"));
                u.setRol(req.getParameter("rol"));
                u.setActivo(Boolean.parseBoolean(req.getParameter("activo")));
                dao.actualizar(u);
                resp.sendRedirect(req.getContextPath() + "/usuarios?exito=actualizado");
            }
            case "/resetear-contrasena" -> {
                int id = Integer.parseInt(req.getParameter("idUsuario"));
                String nueva    = req.getParameter("nuevaContrasena");
                String confirmar = req.getParameter("confirmar");

                if (!nueva.equals(confirmar)) {
                    Usuario u = dao.obtenerPorId(id);
                    req.setAttribute("usuario", u);
                    req.setAttribute("error", "Las contraseñas no coinciden.");
                    req.getRequestDispatcher("/WEB-INF/views/usuarios/editar.jsp").forward(req, resp);
                    return;
                }

                dao.cambiarContrasena(id, nueva);
                Usuario u = dao.obtenerPorId(id);
                req.setAttribute("usuario", u);
                req.setAttribute("exito", "Contraseña restablecida exitosamente.");
                req.getRequestDispatcher("/WEB-INF/views/usuarios/editar.jsp").forward(req, resp);
            }
        }
    }

    private boolean esAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Usuario u = (Usuario) s.getAttribute("usuario");
        return u != null && u.esAdministrador();
    }

    // Método auxiliar para obtener usuario por ID (agregado al DAO)
    private Usuario obtenerUsuarioPorId(int id) {
        return dao.listarTodos().stream()
                .filter(u -> u.getIdUsuario() == id)
                .findFirst()
                .orElse(null);
    }
}
