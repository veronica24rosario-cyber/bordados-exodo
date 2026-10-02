package com.bordados.util;

import com.bordados.dao.ConfiguracionDAO;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class CorreoUtil {

    public static void enviarAlertaStockMinimo(String material, double existencias, double minimo, String unidad) {
        String asunto = "⚠️ Stock bajo: " + material;
        String cuerpo = "<h2>Alerta de stock bajo</h2>" +
                "<p>El material <strong>" + material + "</strong> está por debajo del mínimo.</p>" +
                "<ul><li>Existencias actuales: <strong>" + existencias + " " + unidad + "</strong></li>" +
                "<li>Stock mínimo: <strong>" + minimo + " " + unidad + "</strong></li></ul>" +
                "<p>Por favor realiza una compra pronto.</p>";
        enviarAlerta(asunto, cuerpo);
    }

    public static void enviarAlertaPedido1Dia(String cliente, String descripcion, String fechaEntrega, int idPedido) {
        String asunto = "🚨 Entrega mañana — Pedido #" + idPedido;
        String cuerpo = "<h2>¡Entrega mañana!</h2>" +
                "<p>El pedido <strong>#" + idPedido + "</strong> debe entregarse mañana.</p>" +
                "<ul><li>Cliente: <strong>" + cliente + "</strong></li>" +
                "<li>Descripción: " + descripcion + "</li>" +
                "<li>Fecha de entrega: <strong>" + fechaEntrega + "</strong></li></ul>";
        enviarAlerta(asunto, cuerpo);
    }

    public static void enviarAlertaPedido3Dias(String cliente, String descripcion, String fechaEntrega, int idPedido) {
        String asunto = "⏰ Entrega en 3 días — Pedido #" + idPedido;
        String cuerpo = "<h2>Entrega en 3 días</h2>" +
                "<p>El pedido <strong>#" + idPedido + "</strong> debe entregarse en 3 días.</p>" +
                "<ul><li>Cliente: <strong>" + cliente + "</strong></li>" +
                "<li>Descripción: " + descripcion + "</li>" +
                "<li>Fecha de entrega: <strong>" + fechaEntrega + "</strong></li></ul>";
        enviarAlerta(asunto, cuerpo);
    }

    public static void enviarAlerta(String asunto, String cuerpo) {
        ConfiguracionDAO dao = new ConfiguracionDAO();
        String correoOrigen  = dao.obtener("correo_origen");
        String passwordApp   = dao.obtener("correo_password");
        String correoDestino = dao.obtener("correo_destino");
        String activas       = dao.obtener("notificaciones_activas");

        if (!"true".equals(activas)) return;
        if (correoOrigen.isEmpty() || passwordApp.isEmpty() || correoDestino.isEmpty()) {
            System.out.println("Notificaciones no configuradas. Ve a Configuración para activarlas.");
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(correoOrigen, passwordApp);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(correoOrigen, "Bordados Éxodo"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(correoDestino));
            message.setSubject(asunto);
            message.setContent(cuerpo, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Correo enviado a: " + correoDestino);
        } catch (Exception e) {
            System.out.println("Error al enviar correo: " + e.getMessage());
        }
    }
}
