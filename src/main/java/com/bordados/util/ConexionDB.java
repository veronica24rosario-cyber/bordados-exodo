package com.bordados.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // ============================================================
    //  CONFIGURACIÓN — Cambia estos valores según tu servidor
    // ============================================================
    private static final String URL      = "jdbc:mysql://localhost:3307/bordados_exodo?useSSL=false&serverTimezone=America/Guatemala&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
    private static final String USUARIO  = "root";
    private static final String PASSWORD = "Arosario23$08";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL no encontrado", e);
        }
    }

    public static Connection obtenerConexion() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }

    public static void cerrarConexion(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
