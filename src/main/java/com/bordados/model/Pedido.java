package com.bordados.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Pedido {
    private int idPedido;
    private int idCliente;
    private String clienteNombre;
    private String descripcion;
    private int cantidad;
    private String diseno;
    private String notas;
    private LocalDate fechaRecepcion;
    private LocalDate fechaEntrega;
    private String estado;
    private int idUsuarioRegistro;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
    private byte[] fotoReferencia;
    private String fotoReferenciaTipo;
    private boolean oculto;
    private double total;
    private double anticipo;

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    public double getAnticipo() { return anticipo; }
    public void setAnticipo(double anticipo) { this.anticipo = anticipo; }
    public double getRestante() { return total - anticipo; }

    public Pedido() {}

    public int getIdPedido() { return idPedido; }
    public void setIdPedido(int idPedido) { this.idPedido = idPedido; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public String getClienteNombre() { return clienteNombre; }
    public void setClienteNombre(String clienteNombre) { this.clienteNombre = clienteNombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public String getDiseno() { return diseno; }
    public void setDiseno(String diseno) { this.diseno = diseno; }
    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
    public LocalDate getFechaRecepcion() { return fechaRecepcion; }
    public void setFechaRecepcion(LocalDate fechaRecepcion) { this.fechaRecepcion = fechaRecepcion; }
    public LocalDate getFechaEntrega() { return fechaEntrega; }
    public void setFechaEntrega(LocalDate fechaEntrega) { this.fechaEntrega = fechaEntrega; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public int getIdUsuarioRegistro() { return idUsuarioRegistro; }
    public void setIdUsuarioRegistro(int idUsuarioRegistro) { this.idUsuarioRegistro = idUsuarioRegistro; }
    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }

    public String getEstadoEtiqueta() {
        return switch (estado) {
            case "RECIBIDO"   -> "Recibido";
            case "EN_PROCESO" -> "En proceso";
            case "TERMINADO"  -> "Terminado";
            case "ENTREGADO"  -> "Entregado";
            case "CANCELADO"  -> "Cancelado";
            default           -> estado;
        };
    }

    public byte[] getFotoReferencia() { return fotoReferencia; }
    public void setFotoReferencia(byte[] fotoReferencia) { this.fotoReferencia = fotoReferencia; }
    public String getFotoReferenciaTipo() { return fotoReferenciaTipo; }
    public void setFotoReferenciaTipo(String fotoReferenciaTipo) { this.fotoReferenciaTipo = fotoReferenciaTipo; }
    public boolean isOculto() { return oculto; }
    public void setOculto(boolean oculto) { this.oculto = oculto; }
    public boolean tieneFoto() { return fotoReferencia != null && fotoReferencia.length > 0; }

    public String getEstadoClase() {
        return switch (estado) {
            case "RECIBIDO"   -> "badge-blue";
            case "EN_PROCESO" -> "badge-yellow";
            case "TERMINADO"  -> "badge-green";
            case "ENTREGADO"  -> "badge-green";
            case "CANCELADO"  -> "badge-gray";
            default           -> "badge-gray";
        };
    }
}
