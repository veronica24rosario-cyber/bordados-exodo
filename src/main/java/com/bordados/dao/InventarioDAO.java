package com.bordados.dao;

import com.bordados.model.Inventario;
import com.bordados.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventarioDAO {

    public List<Inventario> listarTodos() {
        List<Inventario> lista = new ArrayList<>();
        String sql = "SELECT * FROM inventario ORDER BY nombre_material";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Inventario> listarStockBajo() {
        List<Inventario> lista = new ArrayList<>();
        String sql = "SELECT * FROM inventario WHERE existencias <= stock_minimo ORDER BY nombre_material";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Inventario obtenerPorId(int id) {
        String sql = "SELECT * FROM inventario WHERE id_material = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertar(Inventario inv) {
        String sql = "INSERT INTO inventario (nombre_material, existencias, stock_minimo, unidad, consumo_mensual) VALUES (?,?,?,?,?)";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inv.getNombreMaterial());
            ps.setDouble(2, inv.getExistencias());
            ps.setDouble(3, inv.getStockMinimo());
            ps.setString(4, inv.getUnidad());
            ps.setDouble(5, inv.getConsumoMensual());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean actualizar(Inventario inv) {
        String sql = "UPDATE inventario SET nombre_material=?, stock_minimo=?, unidad=?, consumo_mensual=? WHERE id_material=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inv.getNombreMaterial());
            ps.setDouble(2, inv.getStockMinimo());
            ps.setString(3, inv.getUnidad());
            ps.setDouble(4, inv.getConsumoMensual());
            ps.setInt(5, inv.getIdMaterial());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean registrarMovimiento(int idMaterial, String tipo, double cantidad,
                                        String descripcion, int idUsuario) {
        Connection conn = null;
        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false);

            // Actualizar existencias
            String sqlUpdate;
            if ("COMPRA".equals(tipo)) {
                sqlUpdate = "UPDATE inventario SET existencias = existencias + ? WHERE id_material = ?";
            } else if ("CONSUMO".equals(tipo)) {
                sqlUpdate = "UPDATE inventario SET existencias = existencias - ?, consumo_mensual = consumo_mensual + ? WHERE id_material = ?";
            } else { // AJUSTE
                sqlUpdate = "UPDATE inventario SET existencias = ? WHERE id_material = ?";
            }

            PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
            if ("CONSUMO".equals(tipo)) {
                psUpdate.setDouble(1, cantidad);
                psUpdate.setDouble(2, cantidad);
                psUpdate.setInt(3, idMaterial);
            } else {
                psUpdate.setDouble(1, cantidad);
                psUpdate.setInt(2, idMaterial);
            }
            psUpdate.executeUpdate();

            // Registrar movimiento
            String sqlMov = "INSERT INTO movimientos_inventario (id_material, tipo, cantidad, descripcion, id_usuario) VALUES (?,?,?,?,?)";
            PreparedStatement psMov = conn.prepareStatement(sqlMov);
            psMov.setInt(1, idMaterial);
            psMov.setString(2, tipo);
            psMov.setDouble(3, cantidad);
            psMov.setString(4, descripcion);
            psMov.setInt(5, idUsuario);
            psMov.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            return false;
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
    }

    public boolean eliminar(int id) {
        Connection conn = null;
        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false);

            // Guardar en papelera
            String sqlPapelera = "INSERT INTO papelera_inventario (id_material_original, nombre_material, " +
                    "existencias, stock_minimo, unidad, consumo_mensual) " +
                    "SELECT id_material, nombre_material, existencias, stock_minimo, unidad, consumo_mensual " +
                    "FROM inventario WHERE id_material = ?";
            PreparedStatement psPapelera = conn.prepareStatement(sqlPapelera);
            psPapelera.setInt(1, id);
            psPapelera.executeUpdate();

            // Eliminar alertas relacionadas
            PreparedStatement psAlertas = conn.prepareStatement("DELETE FROM alertas WHERE id_material = ?");
            psAlertas.setInt(1, id);
            psAlertas.executeUpdate();

            // Eliminar movimientos
            PreparedStatement psMov = conn.prepareStatement("DELETE FROM movimientos_inventario WHERE id_material = ?");
            psMov.setInt(1, id);
            psMov.executeUpdate();

            // Eliminar material
            PreparedStatement psDel = conn.prepareStatement("DELETE FROM inventario WHERE id_material = ?");
            psDel.setInt(1, id);
            psDel.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            return false;
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
    }

    public boolean guardarFoto(int id, byte[] foto, String mimeType) {
        String sql = "UPDATE inventario SET foto=?, foto_tipo=? WHERE id_material=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBytes(1, foto);
            ps.setString(2, mimeType);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int contarStockBajo() {
        String sql = "SELECT COUNT(*) FROM inventario WHERE existencias <= stock_minimo";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Inventario mapear(ResultSet rs) throws SQLException {
        Inventario inv = new Inventario();
        inv.setIdMaterial(rs.getInt("id_material"));
        inv.setNombreMaterial(rs.getString("nombre_material"));
        inv.setExistencias(rs.getDouble("existencias"));
        inv.setStockMinimo(rs.getDouble("stock_minimo"));
        inv.setUnidad(rs.getString("unidad"));
        inv.setConsumoMensual(rs.getDouble("consumo_mensual"));
        Timestamp ts = rs.getTimestamp("fecha_actualizacion");
        if (ts != null) inv.setFechaActualizacion(ts.toLocalDateTime());
        try {
            byte[] foto = rs.getBytes("foto");
            if (foto != null && foto.length > 0) {
                inv.setFoto(foto);
                inv.setFotoTipo(rs.getString("foto_tipo"));
            }
        } catch (SQLException ignored) {}
        return inv;
    }
}
