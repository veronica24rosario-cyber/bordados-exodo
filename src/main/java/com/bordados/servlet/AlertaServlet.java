package com.bordados.servlet;

import com.bordados.dao.AlertaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/alertas/*")
public class AlertaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        if ("/marcar-leida".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            new AlertaDAO().marcarLeida(id);
            String referer = req.getHeader("Referer");
            resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/dashboard");
        }
    }

    private boolean estaAutenticado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("usuario") != null;
    }
}
