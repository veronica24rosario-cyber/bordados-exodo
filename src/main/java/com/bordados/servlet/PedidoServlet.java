package com.bordados.servlet;

import com.bordados.dao.ClienteDAO;
import com.bordados.dao.PedidoDAO;
import com.bordados.model.Pedido;
import com.bordados.model.Usuario;
import com.bordados.service.AlertaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/pedidos/*")
@MultipartConfig(maxFileSize = 20 * 1024 * 1024)
public class PedidoServlet extends HttpServlet {

    private final PedidoDAO dao = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!estaAutenticado(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String path = req.getPathInfo() != null ? req.getPathInfo() : "/";

        switch (path) {
            case "/nuevo" -> {
                req.setAttribute("clientes", new ClienteDAO().listarTodos());
                req.getRequestDispatcher("/WEB-INF/views/pedidos/nuevo.jsp").forward(req, resp);
            }
            case "/editar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("pedido", dao.obtenerPorId(id));
                req.setAttribute("clientes", new ClienteDAO().listarTodos());
                req.getRequestDispatcher("/WEB-INF/views/pedidos/editar.jsp").forward(req, resp);
            }
            case "/eliminados" -> {
                req.setAttribute("pedidos", dao.listarEliminadosUltimos30Dias());
                req.setAttribute("vistaEliminados", true);
                req.getRequestDispatcher("/WEB-INF/views/pedidos/lista.jsp").forward(req, resp);
            }
            case "/ocultos" -> {
                req.setAttribute("pedidos", dao.listarOcultos());
                req.setAttribute("totalOcultos", dao.contarOcultos());
                req.setAttribute("vistaOcultos", true);
                req.getRequestDispatcher("/WEB-INF/views/pedidos/lista.jsp").forward(req, resp);
            }
            case "/eliminar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.eliminar(id);
                resp.sendRedirect(req.getContextPath() + "/pedidos?exito=eliminado");
            }
            case "/ocultar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.ocultarPedido(id);
                String referer = req.getHeader("Referer");
                resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/pedidos");
            }
            case "/restaurar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.restaurarPedido(id);
                resp.sendRedirect(req.getContextPath() + "/pedidos/ocultos");
            }
            case "/detalle" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("pedido", dao.obtenerPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/pedidos/detalle.jsp").forward(req, resp);
            }
            default -> {
                String estado = req.getParameter("estado");
                if (estado != null && !estado.isEmpty()) {
                    req.setAttribute("pedidos", dao.listarPorEstado(estado));
                    req.setAttribute("estadoFiltro", estado);
                } else {
                    req.setAttribute("pedidos", dao.listarTodos());
                }
                req.setAttribute("totalOcultos", dao.contarOcultos());
                req.getRequestDispatcher("/WEB-INF/views/pedidos/lista.jsp").forward(req, resp);
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
                Pedido p = new Pedido();
                p.setIdCliente(Integer.parseInt(req.getParameter("idCliente")));
                p.setDescripcion(req.getParameter("descripcion"));
                p.setCantidad(Integer.parseInt(req.getParameter("cantidad")));
                p.setDiseno(req.getParameter("diseno"));
                p.setNotas(req.getParameter("notas"));
                p.setFechaRecepcion(LocalDate.parse(req.getParameter("fechaRecepcion")));
                p.setFechaEntrega(LocalDate.parse(req.getParameter("fechaEntrega")));
                p.setEstado(req.getParameter("estado"));
                p.setIdUsuarioRegistro(usuario.getIdUsuario());
                try { p.setTotal(Double.parseDouble(req.getParameter("total"))); } catch (Exception e) { p.setTotal(0); }
                try { p.setAnticipo(Double.parseDouble(req.getParameter("anticipo"))); } catch (Exception e) { p.setAnticipo(0); }

                int idNuevo = dao.insertar(p);
                if (idNuevo > 0) {
                    // Obtener nombre del cliente para la alerta
                    Pedido guardado = dao.obtenerPorId(idNuevo);
                    AlertaService.programarAlertasPedido(
                            idNuevo,
                            p.getFechaEntrega(),
                            guardado.getClienteNombre(),
                            p.getDescripcion()
                    );
                    resp.sendRedirect(req.getContextPath() + "/pedidos?exito=creado");
                } else {
                    req.setAttribute("error", "No se pudo guardar el pedido.");
                    req.setAttribute("clientes", new ClienteDAO().listarTodos());
                    req.getRequestDispatcher("/WEB-INF/views/pedidos/nuevo.jsp").forward(req, resp);
                }
            }
            case "/actualizar" -> {
                Pedido p = new Pedido();
                p.setIdPedido(Integer.parseInt(req.getParameter("idPedido")));
                p.setIdCliente(Integer.parseInt(req.getParameter("idCliente")));
                p.setDescripcion(req.getParameter("descripcion"));
                p.setCantidad(Integer.parseInt(req.getParameter("cantidad")));
                p.setDiseno(req.getParameter("diseno"));
                p.setNotas(req.getParameter("notas"));
                p.setFechaRecepcion(LocalDate.parse(req.getParameter("fechaRecepcion")));
                p.setFechaEntrega(LocalDate.parse(req.getParameter("fechaEntrega")));
                p.setEstado(req.getParameter("estado"));
                try { p.setTotal(Double.parseDouble(req.getParameter("total"))); } catch (Exception e) { p.setTotal(0); }
                try { p.setAnticipo(Double.parseDouble(req.getParameter("anticipo"))); } catch (Exception e) { p.setAnticipo(0); }
                dao.actualizar(p);
                resp.sendRedirect(req.getContextPath() + "/pedidos?exito=actualizado");
            }
            case "/estado" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                String nuevoEstado = req.getParameter("estado");
                dao.actualizarEstado(id, nuevoEstado);
                resp.sendRedirect(req.getContextPath() + "/pedidos?exito=estado");
            }
            case "/guardar-foto" -> {
                int id = Integer.parseInt(req.getParameter("idPedido"));
                try {
                    Part filePart = req.getPart("fotoReferencia");
                    if (filePart != null && filePart.getSize() > 0) {
                        byte[] fotoBytes = filePart.getInputStream().readAllBytes();
                        String mimeType = filePart.getContentType();
                        if (mimeType == null || !mimeType.startsWith("image/")) {
                            mimeType = "image/jpeg";
                        }
                        boolean ok = dao.guardarFoto(id, fotoBytes, mimeType);
                        if (ok) {
                            req.setAttribute("exito", "Foto subida exitosamente.");
                        } else {
                            req.setAttribute("error", "No se pudo guardar la foto. Intenta de nuevo.");
                        }
                    } else {
                        req.setAttribute("error", "No se seleccionó ninguna imagen.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Error al subir la foto: " + e.getMessage());
                }
                req.setAttribute("pedido", dao.obtenerPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/pedidos/detalle.jsp").forward(req, resp);
            }
        }
    }

    private boolean estaAutenticado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("usuario") != null;
    }
}
