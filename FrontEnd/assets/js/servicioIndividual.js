$(document).ready(function () {
  const servicio = JSON.parse(localStorage.getItem("servicioDetalle"));

  if (!servicio) {
    alert("No se pudo cargar el servicio.");
    window.location.href = "servicios.html";
    return;
  }

  // Mostrar información del servicio
  $("#serv-img").attr(
    "src",
    servicio.imagen_url || "assets/img/default-servicio.png"
  );
  $("#serv-nombre").text(servicio.nombre);
  $("#serv-precio").text("₡" + Number(servicio.precio).toLocaleString("es-CR"));
  $("#serv-desc").text(servicio.descripcion || "Sin descripción.");
  $("#serv-duracion").text(servicio.duracion || 60);

  // Objeto correcto para citas.js
  const servicioParaAgendar = {
    servicio_id: servicio.servicio_id, //  EL ÚNICO ID CORRECTO
    nombre: servicio.nombre,
    precio: servicio.precio,
    imagen_url: servicio.imagen_url,
    descripcion: servicio.descripcion,
    duracion: servicio.duracion,
  };

  $("a[href='citas.html']").on("click", function () {
    localStorage.setItem(
      "servicioSeleccionado",
      JSON.stringify(servicioParaAgendar)
    );
  });
});
