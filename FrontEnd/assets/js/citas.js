$(document).ready(function () {
  const serv = JSON.parse(localStorage.getItem("servicioSeleccionado"));
  const usuario = JSON.parse(localStorage.getItem("usuario"));

  // Validación de usuario
  if (!usuario) {
    alert("Debe iniciar sesión para agendar una cita.");
    window.location.href = "login.html";
    return;
  }

  // Validar servicio seleccionado
  if (!serv) {
    alert("No seleccionaste un servicio.");
    window.location.href = "servicios.html";
    return;
  }

  // Mostrar datos del servicio
  $("#serv-nombre").text(serv.nombre);
  $("#serv-precio").text("₡" + Number(serv.precio).toLocaleString("es-CR"));

  // Enviar cita
  $("#form-cita").submit(function (e) {
    e.preventDefault();

    const fecha = $("#cita-fecha").val();
    const hora = $("#cita-hora").val();
    const notas = $("#cita-notas").val();

    if (!fecha || !hora) {
      alert("Debe seleccionar fecha y hora.");
      return;
    }

    const fechaHora = `${fecha} ${hora}:00`;

    const payload = {
      cliente_id: usuario.cliente_id,
      servicio_id: serv.servicio_id,
      fecha_hora: fechaHora,
      notas: notas,
    };

    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/citas",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),

      success: function () {
        alert("Cita agendada exitosamente.");
        localStorage.removeItem("servicioSeleccionado");
        window.location.href = "misCitas.html";
      },

      error: function (xhr) {
        let detalle =
          "Error al agendar cita, ya hay un servicio agendado a esa hora.";

        if (xhr.responseJSON?.detalle) {
          detalle = xhr.responseJSON.detalle;

          // Limpia formato ORA-xxxx:
          detalle = detalle.replace(/ORA-\d+: /, "");
        }

        alert(detalle);
        console.error("ERROR AL CREAR CITA:", xhr.responseText);
      },
    });
  });
});
