package com.bordados.dao;

import com.bordados.model.Pedido;
import com.bordados.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    public List<Pedido> listarTodos() {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS cliente_nombre FROM pedidos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "ORDER BY p.fecha_entrega ASC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Pedido> listarActivos() {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS cliente_nombre FROM pedidos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "WHERE p.estado NOT IN ('ENTREGADO','CANCELADO') " +
                     "ORDER BY p.fecha_entrega ASC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Pedido> listarPorEstado(String estado) {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS cliente_nombre FROM pedidos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "WHERE p.estado = ? ORDER BY p.fecha_entrega ASC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Pedido obtenerPorId(int id) {
        String sql = "SELECT p.*, c.nombre AS cliente_nombre FROM pedidos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente WHERE p.id_pedido = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int insertar(Pedido p) {
        String sql = "INSERT INTO pedidos (id_cliente, descripcion, cantidad, diseno, notas, " +
                     "fecha_recepcion, fecha_entrega, estado, total, anticipo, id_usuario_registro) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getIdCliente());
            ps.setString(2, p.getDescripcion());
            ps.setInt(3, p.getCantidad());
            ps.setString(4, p.getDiseno());
            ps.setString(5, p.getNotas());
            ps.setDate(6, Date.valueOf(p.getFechaRecepcion()));
            ps.setDate(7, Date.valueOf(p.getFechaEntrega()));
            ps.setString(8, p.getEstado());
            ps.setDouble(9, p.getTotal());
            ps.setDouble(10, p.getAnticipo());
            ps.setInt(11, p.getIdUsuarioRegistro());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean actualizar(Pedido p) {
        String sql = "UPDATE pedidos SET id_cliente=?, descripcion=?, cantidad=?, diseno=?, notas=?, " +
                     "fecha_recepcion=?, fecha_entrega=?, estado=?, total=?, anticipo=? WHERE id_pedido=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getIdCliente());
            ps.setString(2, p.getDescripcion());
            ps.setInt(3, p.getCantidad());
            ps.setString(4, p.getDiseno());
            ps.setString(5, p.getNotas());
            ps.setDate(6, Date.valueOf(p.getFechaRecepcion()));
            ps.setDate(7, Date.valueOf(p.getFechaEntrega()));
            ps.setString(8, p.getEstado());
            ps.setDouble(9, p.getTotal());
            ps.setDouble(10, p.getAnticipo());
            ps.setInt(11, p.getIdPedido());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean actualizarEstado(int id, String estado) {
        String sql = "UPDATE pedidos SET estado=? WHERE id_pedido=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int id) {
        Connection conn = null;
        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false);

            // Guardar en papelera antes de eliminar
            String sqlPapelera = "INSERT INTO papelera_pedidos (id_pedido_original, id_cliente, cliente_nombre, " +
                    "descripcion, cantidad, diseno, notas, fecha_recepcion, fecha_entrega, estado, total, anticipo) " +
                    "SELECT p.id_pedido, p.id_cliente, c.nombre, p.descripcion, p.cantidad, p.diseno, p.notas, " +
                    "p.fecha_recepcion, p.fecha_entrega, p.estado, p.total, p.anticipo " +
                    "FROM pedidos p JOIN clientes c ON p.id_cliente = c.id_cliente WHERE p.id_pedido = ?";
            PreparedStatement psPapelera = conn.prepareStatement(sqlPapelera);
            psPapelera.setInt(1, id);
            psPapelera.executeUpdate();

            // Eliminar alertas relacionadas
            PreparedStatement psAlertas = conn.prepareStatement("DELETE FROM alertas WHERE id_pedido = ?");
            psAlertas.setInt(1, id);
            psAlertas.executeUpdate();

            // Eliminar pedido
            PreparedStatement psDel = conn.prepareStatement("DELETE FROM pedidos WHERE id_pedido = ?");
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

    public List<Pedido> listarEliminadosUltimos30Dias() {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT id_pedido_original AS id_pedido, id_cliente, cliente_nombre, descripcion, " +
                     "cantidad, diseno, notas, fecha_recepcion, fecha_entrega, estado, total, anticipo, " +
                     "fecha_eliminado AS fecha_creacion FROM papelera_pedidos " +
                     "WHERE fecha_eliminado >= DATE_SUB(NOW(), INTERVAL 30 DAY) ORDER BY fecha_eliminado DESC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Pedido p = new Pedido();
                p.setIdPedido(rs.getInt("id_pedido"));
                p.setIdCliente(rs.getInt("id_cliente"));
                p.setClienteNombre(rs.getString("cliente_nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setCantidad(rs.getInt("cantidad"));
                p.setDiseno(rs.getString("diseno"));
                p.setNotas(rs.getString("notas"));
                java.sql.Date fr = rs.getDate("fecha_recepcion");
                if (fr != null) p.setFechaRecepcion(fr.toLocalDate());
                java.sql.Date fe = rs.getDate("fecha_entrega");
                if (fe != null) p.setFechaEntrega(fe.toLocalDate());
                p.setEstado(rs.getString("estado"));
                p.setTotal(rs.getDouble("total"));
                p.setAnticipo(rs.getDouble("anticipo"));
                java.sql.Timestamp tc = rs.getTimestamp("fecha_creacion");
                if (tc != null) p.setFechaCreacion(tc.toLocalDateTime());
                lista.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean ocultarPedido(int id) {
        String sql = "UPDATE pedidos SET oculto = 1 WHERE id_pedido = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean guardarFoto(int id, byte[] foto, String mimeType) {
        String sql = "UPDATE pedidos SET foto_referencia=?, foto_referencia_tipo=? WHERE id_pedido=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBytes(1, foto);
            ps.setString(2, mimeType);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int contarOcultos() {
        String sql = "SELECT COUNT(*) FROM pedidos WHERE oculto = 1";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Pedido> listarOcultos() {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre AS cliente_nombre FROM pedidos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "WHERE p.oculto = 1 ORDER BY p.fecha_entrega DESC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean restaurarPedido(int id) {
        String sql = "UPDATE pedidos SET oculto = 0 WHERE id_pedido = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int contarActivos() {
        String sql = "SELECT COUNT(*) FROM pedidos WHERE estado NOT IN ('ENTREGADO','CANCELADO')";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int contarEntregadosMes() {
        String sql = "SELECT COUNT(*) FROM pedidos WHERE estado='ENTREGADO' " +
                     "AND MONTH(fecha_actualizacion)=MONTH(NOW()) AND YEAR(fecha_actualizacion)=YEAR(NOW())";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Pedido mapear(ResultSet rs) throws SQLException {
        Pedido p = new Pedido();
        p.setIdPedido(rs.getInt("id_pedido"));
        p.setIdCliente(rs.getInt("id_cliente"));
        p.setClienteNombre(rs.getString("cliente_nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setCantidad(rs.getInt("cantidad"));
        p.setDiseno(rs.getString("diseno"));
        p.setNotas(rs.getString("notas"));
        Date fr = rs.getDate("fecha_recepcion");
        if (fr != null) p.setFechaRecepcion(fr.toLocalDate());
        Date fe = rs.getDate("fecha_entrega");
        if (fe != null) p.setFechaEntrega(fe.toLocalDate());
        p.setEstado(rs.getString("estado"));
        p.setTotal(rs.getDouble("total"));
        p.setAnticipo(rs.getDouble("anticipo"));
        p.setOculto(rs.getBoolean("oculto"));
        try {
            byte[] foto = rs.getBytes("foto_referencia");
            if (foto != null && foto.length > 0) {
                p.setFotoReferencia(foto);
                p.setFotoReferenciaTipo(rs.getString("foto_referencia_tipo"));
            }
        } catch (SQLException ignored) {}
        Timestamp tc = rs.getTimestamp("fecha_creacion");
        if (tc != null) p.setFechaCreacion(tc.toLocalDateTime());
        return p;
    }
}
