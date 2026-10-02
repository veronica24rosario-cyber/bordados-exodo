package com.bordados.servlet;

import com.bordados.dao.ClienteDAO;
import com.bordados.model.Cliente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/clientes/*")
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        switch (path) {
            case "/nuevo" -> req.getRequestDispatcher("/WEB-INF/views/clientes/nuevo.jsp").forward(req, resp);
            case "/editar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("cliente", dao.obtenerPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/clientes/editar.jsp").forward(req, resp);
            }
            case "/eliminar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.eliminar(id);
                resp.sendRedirect(req.getContextPath() + "/clientes?exito=eliminado");
            }
            default -> {
                req.setAttribute("clientes", dao.listarTodos());
                req.getRequestDispatcher("/WEB-INF/views/clientes/lista.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        switch (path) {
            case "/guardar" -> {
                Cliente c = new Cliente();
                c.setNombre(req.getParameter("nombre"));
                c.setTelefono(req.getParameter("telefono"));
                c.setCorreo(req.getParameter("correo"));
                c.setDireccion(req.getParameter("direccion"));
                dao.insertar(c);
                resp.sendRedirect(req.getContextPath() + "/clientes?exito=creado");
            }
            case "/actualizar" -> {
                Cliente c = new Cliente();
                c.setIdCliente(Integer.parseInt(req.getParameter("idCliente")));
                c.setNombre(req.getParameter("nombre"));
                c.setTelefono(req.getParameter("telefono"));
                c.setCorreo(req.getParameter("correo"));
                c.setDireccion(req.getParameter("direccion"));
                dao.actualizar(c);
                resp.sendRedirect(req.getContextPath() + "/clientes?exito=actualizado");
            }
        }
    }

    private boolean estaAutenticado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("usuario") != null;
    }
}
