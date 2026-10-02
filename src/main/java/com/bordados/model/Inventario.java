package com.bordados.model;

import java.time.LocalDateTime;

public class Inventario {
    private int idMaterial;
    private String nombreMaterial;
    private double existencias;
    private double stockMinimo;
    private String unidad;
    private double consumoMensual;
    private LocalDateTime fechaActualizacion;
    private byte[] foto;
    private String fotoTipo;

    public Inventario() {}

    public int getIdMaterial() { return idMaterial; }
    public void setIdMaterial(int idMaterial) { this.idMaterial = idMaterial; }
    public String getNombreMaterial() { return nombreMaterial; }
    public void setNombreMaterial(String nombreMaterial) { this.nombreMaterial = nombreMaterial; }
    public double getExistencias() { return existencias; }
    public void setExistencias(double existencias) { this.existencias = existencias; }
    public double getStockMinimo() { return stockMinimo; }
    public void setStockMinimo(double stockMinimo) { this.stockMinimo = stockMinimo; }
    public String getUnidad() { return unidad; }
    public void setUnidad(String unidad) { this.unidad = unidad; }
    public double getConsumoMensual() { return consumoMensual; }
    public void setConsumoMensual(double consumoMensual) { this.consumoMensual = consumoMensual; }
    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }

    public byte[] getFoto() { return foto; }
    public void setFoto(byte[] foto) { this.foto = foto; }
    public String getFotoTipo() { return fotoTipo; }
    public void setFotoTipo(String fotoTipo) { this.fotoTipo = fotoTipo; }
    public boolean tieneFoto() { return foto != null && foto.length > 0; }

    public boolean isStockBajo() { return existencias <= stockMinimo; }

    public String getEstadoStock() {
        if (existencias <= stockMinimo) return "Stock bajo";
        if (existencias <= stockMinimo * 1.5) return "Por agotarse";
        return "Normal";
    }

    public String getClaseEstado() {
        if (existencias <= stockMinimo) return "badge-red";
        if (existencias <= stockMinimo * 1.5) return "badge-yellow";
        return "badge-green";
    }
}
