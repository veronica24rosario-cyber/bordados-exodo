package com.bordados.servlet;

import com.bordados.util.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/foto/*")
public class FotoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null) { resp.sendError(404); return; }

        String[] partes = path.split("/");
        if (partes.length < 3) { resp.sendError(404); return; }

        String tipo = partes[1]; // usuario, pedido, material
        int id;
        try { id = Integer.parseInt(partes[2]); }
        catch (NumberFormatException e) { resp.sendError(404); return; }

        byte[] foto = null;
        String mimeType = "image/jpeg";

        try (Connection conn = ConexionDB.obtenerConexion()) {
            String sql;
            String colFoto, colTipo;

            switch (tipo) {
                case "usuario" -> { sql = "SELECT foto, foto_tipo FROM usuarios WHERE id_usuario = ?"; colFoto = "foto"; colTipo = "foto_tipo"; }
                case "pedido"  -> { sql = "SELECT foto_referencia AS foto, foto_referencia_tipo AS foto_tipo FROM pedidos WHERE id_pedido = ?"; colFoto = "foto"; colTipo = "foto_tipo"; }
                case "material"-> { sql = "SELECT foto, foto_tipo FROM inventario WHERE id_material = ?"; colFoto = "foto"; colTipo = "foto_tipo"; }
                default        -> { resp.sendError(404); return; }
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    foto = rs.getBytes(colFoto);
                    String t = rs.getString(colTipo);
                    if (t != null && !t.isEmpty()) mimeType = t;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        if (foto == null || foto.length == 0) {
            resp.sendError(404);
            return;
        }

        resp.setContentType(mimeType);
        resp.setContentLength(foto.length);
        resp.getOutputStream().write(foto);
    }
}
