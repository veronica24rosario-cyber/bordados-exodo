package com.bordados.servlet;

import com.bordados.service.AlertaService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Iniciando Sistema Bordados Éxodo...");
        AlertaService.iniciar();
        System.out.println("Sistema iniciado correctamente.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        AlertaService.detener();
        System.out.println("Sistema detenido.");
    }
}
