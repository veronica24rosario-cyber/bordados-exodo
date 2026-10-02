package com.bordados.dao;

import com.bordados.util.ConexionDB;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class ConfiguracionDAO {

    public String obtener(String clave) {
        String sql = "SELECT valor FROM configuracion WHERE clave = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, clave);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("valor");
        } catch (SQLException e) { e.printStackTrace(); }
        return "";
    }

    public Map<String, String> obtenerTodas() {
        Map<String, String> config = new HashMap<>();
        String sql = "SELECT clave, valor FROM configuracion";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                config.put(rs.getString("clave"), rs.getString("valor"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return config;
    }

    public boolean guardar(String clave, String valor) {
        String sql = "INSERT INTO configuracion (clave, valor) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE valor = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, clave);
            ps.setString(2, valor);
            ps.setString(3, valor);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
