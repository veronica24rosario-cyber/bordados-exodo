package com.bordados.servlet;

import com.bordados.dao.AlertaDAO;
import com.bordados.dao.ClienteDAO;
import com.bordados.dao.InventarioDAO;
import com.bordados.dao.PedidoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        PedidoDAO    pedidoDAO    = new PedidoDAO();
        InventarioDAO invDAO      = new InventarioDAO();
        ClienteDAO   clienteDAO  = new ClienteDAO();
        AlertaDAO    alertaDAO   = new AlertaDAO();

        req.setAttribute("pedidosActivos",    pedidoDAO.contarActivos());
        req.setAttribute("entregadosMes",     pedidoDAO.contarEntregadosMes());
        req.setAttribute("stockBajo",         invDAO.contarStockBajo());
        req.setAttribute("totalClientes",     clienteDAO.contarTotal());
        req.setAttribute("alertasNoLeidas",   alertaDAO.contarNoLeidas());
        req.setAttribute("alertas",           alertaDAO.listarNoLeidas());
        req.setAttribute("pedidosRecientes",  pedidoDAO.listarActivos());
        req.setAttribute("pedidosOcultos",    pedidoDAO.contarOcultos());

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }

    private boolean estaAutenticado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("usuario") != null;
    }
}
