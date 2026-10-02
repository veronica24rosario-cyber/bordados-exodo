package com.bordados.model;

import java.time.LocalDateTime;

public class Alerta {
    private int idAlerta;
    private String tipo;
    private Integer idPedido;
    private Integer idMaterial;
    private String mensaje;
    private boolean leida;
    private boolean correoEnviado;
    private LocalDateTime fechaAlerta;
    private LocalDateTime fechaCreacion;

    public Alerta() {}

    public int getIdAlerta() { return idAlerta; }
    public void setIdAlerta(int idAlerta) { this.idAlerta = idAlerta; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public Integer getIdPedido() { return idPedido; }
    public void setIdPedido(Integer idPedido) { this.idPedido = idPedido; }
    public Integer getIdMaterial() { return idMaterial; }
    public void setIdMaterial(Integer idMaterial) { this.idMaterial = idMaterial; }
    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
    public boolean isLeida() { return leida; }
    public void setLeida(boolean leida) { this.leida = leida; }
    public boolean isCorreoEnviado() { return correoEnviado; }
    public void setCorreoEnviado(boolean correoEnviado) { this.correoEnviado = correoEnviado; }
    public LocalDateTime getFechaAlerta() { return fechaAlerta; }
    public void setFechaAlerta(LocalDateTime fechaAlerta) { this.fechaAlerta = fechaAlerta; }
    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public String getIcono() {
        return switch (tipo) {
            case "ENTREGA_1DIA"  -> "ti-alert-triangle";
            case "ENTREGA_3DIAS" -> "ti-calendar";
            case "STOCK_MINIMO"  -> "ti-package";
            default              -> "ti-bell";
        };
    }

    public String getClase() {
        return switch (tipo) {
            case "ENTREGA_1DIA"  -> "alert-danger";
            case "ENTREGA_3DIAS" -> "alert-warning";
            case "STOCK_MINIMO"  -> "alert-warning";
            default              -> "alert-info";
        };
    }
}
