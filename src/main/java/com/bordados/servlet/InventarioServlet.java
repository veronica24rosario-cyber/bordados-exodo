package com.bordados.servlet;

import com.bordados.dao.InventarioDAO;
import com.bordados.model.Inventario;
import com.bordados.model.Usuario;
import com.bordados.service.AlertaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/inventario/*")
@MultipartConfig(maxFileSize = 20 * 1024 * 1024)
public class InventarioServlet extends HttpServlet {

    private final InventarioDAO dao = new InventarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        switch (path) {
            case "/nuevo" -> req.getRequestDispatcher("/WEB-INF/views/inventario/nuevo.jsp").forward(req, resp);
            case "/editar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("material", dao.obtenerPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/inventario/editar.jsp").forward(req, resp);
            }
            case "/movimiento" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("material", dao.obtenerPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/inventario/movimiento.jsp").forward(req, resp);
            }
            case "/eliminar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.eliminar(id);
                resp.sendRedirect(req.getContextPath() + "/inventario?exito=eliminado");
            }
            default -> {
                req.setAttribute("materiales", dao.listarTodos());
                req.setAttribute("stockBajo", dao.contarStockBajo());
                req.getRequestDispatcher("/WEB-INF/views/inventario/lista.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";
        Usuario usuario = (Usuario) req.getSession().getAttribute("usuario");

        switch (path) {
            case "/guardar" -> {
                Inventario inv = new Inventario();
                inv.setNombreMaterial(req.getParameter("nombreMaterial"));
                inv.setExistencias(Double.parseDouble(req.getParameter("existencias")));
                inv.setStockMinimo(Double.parseDouble(req.getParameter("stockMinimo")));
                inv.setUnidad(req.getParameter("unidad"));
                inv.setConsumoMensual(Double.parseDouble(req.getParameter("consumoMensual")));
                dao.insertar(inv);
                AlertaService.verificarStockMateriales();
                resp.sendRedirect(req.getContextPath() + "/inventario?exito=creado");
            }
            case "/actualizar" -> {
                Inventario inv = new Inventario();
                inv.setIdMaterial(Integer.parseInt(req.getParameter("idMaterial")));
                inv.setNombreMaterial(req.getParameter("nombreMaterial"));
                inv.setStockMinimo(Double.parseDouble(req.getParameter("stockMinimo")));
                inv.setUnidad(req.getParameter("unidad"));
                inv.setConsumoMensual(Double.parseDouble(req.getParameter("consumoMensual")));
                dao.actualizar(inv);
                resp.sendRedirect(req.getContextPath() + "/inventario?exito=actualizado");
            }
            case "/guardar-foto" -> {
                int id = Integer.parseInt(req.getParameter("idMaterial"));
                try {
                    Part filePart = req.getPart("foto");
                    if (filePart != null && filePart.getSize() > 0) {
                        byte[] fotoBytes = filePart.getInputStream().readAllBytes();
                        String mimeType  = filePart.getContentType();
                        dao.guardarFoto(id, fotoBytes, mimeType);
                    }
                } catch (Exception e) { e.printStackTrace(); }
                resp.sendRedirect(req.getContextPath() + "/inventario/editar?id=" + id);
            }
            case "/registrar-movimiento" -> {
                int idMaterial  = Integer.parseInt(req.getParameter("idMaterial"));
                String tipo     = req.getParameter("tipo");
                double cantidad = Double.parseDouble(req.getParameter("cantidad"));
                String desc     = req.getParameter("descripcion");
                dao.registrarMovimiento(idMaterial, tipo, cantidad, desc, usuario.getIdUsuario());
                AlertaService.verificarStockMateriales();
                resp.sendRedirect(req.getContextPath() + "/inventario?exito=movimiento");
            }
        }
    }

    private boolean estaAutenticado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("usuario") != null;
    }
}
