// Bordados Éxodo — JavaScript principal

// Auto-ocultar alertas de éxito después de 4 segundos
document.addEventListener('DOMContentLoaded', function () {
    const alertas = document.querySelectorAll('.alert-success');
    alertas.forEach(function (alerta) {
        setTimeout(function () {
            alerta.style.transition = 'opacity 0.5s';
            alerta.style.opacity = '0';
            setTimeout(function () { alerta.remove(); }, 500);
        }, 4000);
    });

    // Confirmar acciones destructivas
    document.querySelectorAll('[data-confirm]').forEach(function (el) {
        el.addEventListener('click', function (e) {
            if (!confirm(el.dataset.confirm)) e.preventDefault();
        });
    });
});
