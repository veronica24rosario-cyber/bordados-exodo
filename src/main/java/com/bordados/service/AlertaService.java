package com.bordados.service;

import com.bordados.dao.AlertaDAO;
import com.bordados.dao.InventarioDAO;
import com.bordados.dao.PedidoDAO;
import com.bordados.model.Alerta;
import com.bordados.model.Inventario;
import com.bordados.model.Pedido;
import com.bordados.util.ConexionDB;
import com.bordados.util.CorreoUtil;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class AlertaService {

    private static Scheduler scheduler;

    // ============================================================
    //  Iniciar el scheduler (se llama al arrancar la aplicación)
    // ============================================================
    public static void iniciar() {
        try {
            scheduler = StdSchedulerFactory.getDefaultScheduler();
            scheduler.start();

            // Verificar alertas cada hora
            JobDetail job = JobBuilder.newJob(VerificarAlertasJob.class)
                    .withIdentity("verificarAlertas", "bordados")
                    .build();

            Trigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity("triggerAlertas", "bordados")
                    .startNow()
                    .withSchedule(SimpleScheduleBuilder.simpleSchedule()
                            .withIntervalInHours(1)
                            .repeatForever())
                    .build();

            scheduler.scheduleJob(job, trigger);
            System.out.println("Scheduler de alertas iniciado correctamente.");
        } catch (SchedulerException e) {
            System.err.println("Error al iniciar el scheduler: " + e.getMessage());
        }
    }

    public static void detener() {
        try {
            if (scheduler != null && scheduler.isStarted()) {
                scheduler.shutdown();
            }
        } catch (SchedulerException e) {
            System.err.println("Error al detener el scheduler: " + e.getMessage());
        }
    }

    // ============================================================
    //  Programar alertas para un pedido nuevo
    // ============================================================
    public static void programarAlertasPedido(int idPedido, LocalDate fechaEntrega,
                                               String clienteNombre, String descripcion) {
        AlertaDAO alertaDAO = new AlertaDAO();
        LocalDate hoy = LocalDate.now();

        // Alerta 3 días antes
        LocalDate fecha3Dias = fechaEntrega.minusDays(3);
        if (!alertaDAO.existeAlerta("ENTREGA_3DIAS", idPedido, null)) {
            Alerta a3 = new Alerta();
            a3.setTipo("ENTREGA_3DIAS");
            a3.setIdPedido(idPedido);
            a3.setMensaje("El pedido #" + idPedido + " (" + clienteNombre + ") se entrega en 3 días: " + fechaEntrega);
            a3.setFechaAlerta(fecha3Dias.atTime(8, 0));
            alertaDAO.insertar(a3);
        }

        // Alerta 1 día antes
        LocalDate fecha1Dia = fechaEntrega.minusDays(1);
        if (!alertaDAO.existeAlerta("ENTREGA_1DIA", idPedido, null)) {
            Alerta a1 = new Alerta();
            a1.setTipo("ENTREGA_1DIA");
            a1.setIdPedido(idPedido);
            a1.setMensaje("URGENTE: El pedido #" + idPedido + " (" + clienteNombre + ") se entrega mañana: " + fechaEntrega);
            a1.setFechaAlerta(fecha1Dia.atTime(8, 0));
            alertaDAO.insertar(a1);
        }
    }

    // ============================================================
    //  Verificar y generar alertas de stock
    // ============================================================
    public static void verificarStockMateriales() {
        AlertaDAO alertaDAO = new AlertaDAO();
        InventarioDAO invDAO = new InventarioDAO();
        List<Inventario> stockBajo = invDAO.listarStockBajo();

        for (Inventario inv : stockBajo) {
            if (!alertaDAO.existeAlerta("STOCK_MINIMO", null, inv.getIdMaterial())) {
                Alerta alerta = new Alerta();
                alerta.setTipo("STOCK_MINIMO");
                alerta.setIdMaterial(inv.getIdMaterial());
                alerta.setMensaje("Stock bajo: " + inv.getNombreMaterial() +
                        " — Existencias: " + inv.getExistencias() + " " + inv.getUnidad() +
                        " (Mínimo: " + inv.getStockMinimo() + " " + inv.getUnidad() + ")");
                alerta.setFechaAlerta(LocalDateTime.now());
                alertaDAO.insertar(alerta);

                // Enviar correo
                CorreoUtil.enviarAlertaStockMinimo(
                        inv.getNombreMaterial(),
                        inv.getExistencias(),
                        inv.getStockMinimo(),
                        inv.getUnidad()
                );
            }
        }
    }

    // ============================================================
    //  Enviar correos de alertas pendientes
    // ============================================================
    public static void procesarCorreosPendientes() {
        AlertaDAO alertaDAO = new AlertaDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();
        List<Alerta> pendientes = alertaDAO.listarPendientesEnvio();

        for (Alerta alerta : pendientes) {
            try {
                if ("ENTREGA_1DIA".equals(alerta.getTipo()) && alerta.getIdPedido() != null) {
                    Pedido pedido = pedidoDAO.obtenerPorId(alerta.getIdPedido());
                    if (pedido != null && !"ENTREGADO".equals(pedido.getEstado()) && !"CANCELADO".equals(pedido.getEstado())) {
                        CorreoUtil.enviarAlertaPedido1Dia(
                                pedido.getClienteNombre(),
                                pedido.getDescripcion(),
                                pedido.getFechaEntrega().toString(),
                                pedido.getIdPedido()
                        );
                        alertaDAO.marcarCorreoEnviado(alerta.getIdAlerta());
                    }
                } else if ("ENTREGA_3DIAS".equals(alerta.getTipo()) && alerta.getIdPedido() != null) {
                    Pedido pedido = pedidoDAO.obtenerPorId(alerta.getIdPedido());
                    if (pedido != null && !"ENTREGADO".equals(pedido.getEstado()) && !"CANCELADO".equals(pedido.getEstado())) {
                        CorreoUtil.enviarAlertaPedido3Dias(
                                pedido.getClienteNombre(),
                                pedido.getDescripcion(),
                                pedido.getFechaEntrega().toString(),
                                pedido.getIdPedido()
                        );
                        alertaDAO.marcarCorreoEnviado(alerta.getIdAlerta());
                    }
                }
            } catch (Exception e) {
                System.err.println("Error al procesar correo de alerta " + alerta.getIdAlerta() + ": " + e.getMessage());
            }
        }
    }

    // ============================================================
    //  Job de Quartz que se ejecuta cada hora
    // ============================================================
    public static class VerificarAlertasJob implements Job {
        @Override
        public void execute(JobExecutionContext context) {
            System.out.println("Ejecutando verificación de alertas: " + LocalDateTime.now());
            verificarStockMateriales();
            procesarCorreosPendientes();
        }
    }
}
