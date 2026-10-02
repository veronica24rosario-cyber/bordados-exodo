package com.bordados.dao;

import com.bordados.model.Alerta;
import com.bordados.util.ConexionDB;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AlertaDAO {

    public List<Alerta> listarNoLeidas() {
        List<Alerta> lista = new ArrayList<>();
        String sql = "SELECT * FROM alertas WHERE leida = 0 ORDER BY fecha_creacion DESC LIMIT 20";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public int contarNoLeidas() {
        String sql = "SELECT COUNT(*) FROM alertas WHERE leida = 0";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean insertar(Alerta a) {
        String sql = "INSERT INTO alertas (tipo, id_pedido, id_material, mensaje, fecha_alerta) VALUES (?,?,?,?,?)";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getTipo());
            if (a.getIdPedido() != null) ps.setInt(2, a.getIdPedido()); else ps.setNull(2, Types.INTEGER);
            if (a.getIdMaterial() != null) ps.setInt(3, a.getIdMaterial()); else ps.setNull(3, Types.INTEGER);
            ps.setString(4, a.getMensaje());
            ps.setTimestamp(5, Timestamp.valueOf(a.getFechaAlerta()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean marcarLeida(int idAlerta) {
        String sql = "UPDATE alertas SET leida = 1 WHERE id_alerta = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAlerta);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean marcarCorreoEnviado(int idAlerta) {
        String sql = "UPDATE alertas SET correo_enviado = 1 WHERE id_alerta = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAlerta);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Alerta> listarPendientesEnvio() {
        List<Alerta> lista = new ArrayList<>();
        String sql = "SELECT * FROM alertas WHERE correo_enviado = 0 AND fecha_alerta <= NOW()";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean existeAlerta(String tipo, Integer idPedido, Integer idMaterial) {
        String sql = "SELECT COUNT(*) FROM alertas WHERE tipo=? AND id_pedido<=>? AND id_material<=>?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tipo);
            if (idPedido != null) ps.setInt(2, idPedido); else ps.setNull(2, Types.INTEGER);
            if (idMaterial != null) ps.setInt(3, idMaterial); else ps.setNull(3, Types.INTEGER);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Alerta mapear(ResultSet rs) throws SQLException {
        Alerta a = new Alerta();
        a.setIdAlerta(rs.getInt("id_alerta"));
        a.setTipo(rs.getString("tipo"));
        int idP = rs.getInt("id_pedido");
        if (!rs.wasNull()) a.setIdPedido(idP);
        int idM = rs.getInt("id_material");
        if (!rs.wasNull()) a.setIdMaterial(idM);
        a.setMensaje(rs.getString("mensaje"));
        a.setLeida(rs.getBoolean("leida"));
        a.setCorreoEnviado(rs.getBoolean("correo_enviado"));
        Timestamp fa = rs.getTimestamp("fecha_alerta");
        if (fa != null) a.setFechaAlerta(fa.toLocalDateTime());
        Timestamp fc = rs.getTimestamp("fecha_creacion");
        if (fc != null) a.setFechaCreacion(fc.toLocalDateTime());
        return a;
    }
}
