$(document).ready(function () {
  // Obtener el servicio guardado en localStorage
  const servicio = JSON.parse(localStorage.getItem("servicioDetalle"));

  if (!servicio) {
    alert("No se pudo cargar el servicio.");
    window.location.href = "servicios.html";
    return;
  }

  // =============================
  // Pintar información del servicio
  // =============================
  $("#serv-img").attr(
    "src",
    servicio.imagen_url || servicio.imagen || "assets/img/default-servicio.png"
  );
  $("#serv-nombre").text(servicio.nombre);
  $("#serv-precio").text(
    "₡" + Number(servicio.precio || 0).toLocaleString("es-CR")
  );
  $("#serv-desc").text(servicio.descripcion || "Sin descripción.");
  $("#serv-duracion").text(servicio.duracion || 60);

  // =============================
  // Preparar objeto para agendar cita
  // (compatible con citas.js que usa serv.id)
  // =============================
  const servicioParaAgendar = {
    // aseguramos que siempre haya "id"
    id: servicio.id || servicio.servicio_id,
    // y también dejamos "servicio_id" por si lo necesitas después
    servicio_id: servicio.servicio_id || servicio.id,
    nombre: servicio.nombre,
    precio: servicio.precio,
    imagen: servicio.imagen_url || servicio.imagen,
    descripcion: servicio.descripcion,
    duracion: servicio.duracion,
  };

  // =============================
  // Guardar el servicio antes de ir a citas.html
  // =============================
  $("a[href='citas.html']").on("click", function () {
    localStorage.setItem(
      "servicioSeleccionado",
      JSON.stringify(servicioParaAgendar)
    );
  });
});
