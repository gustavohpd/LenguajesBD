$(document).ready(function () {
  const id = new URLSearchParams(window.location.search).get("id");

  if (!id) {
    alert("Producto no encontrado");
    return;
  }

  $.ajax({
    url:
      "http://localhost/LenguajesBD/API/public/index.php/api/productos/" + id,
    method: "GET",
    dataType: "json",
    success: function (p) {
      const imagen =
        p.imagen_url && p.imagen_url.trim() !== ""
          ? p.imagen_url
          : "assets/img/default.png";

      $("#prod-img").attr("src", imagen);
      $("#prod-nombre").text(p.nombre);

      const precioFormateado = `₡${Number(p.precio).toLocaleString("es-CR")}`;
      $("#prod-precio").text(precioFormateado);

      $("#prod-desc").text(p.descripcion || "Sin descripción disponible");

      // ===========================
      // BOTÓN COMPRAR
      // ===========================
      $("#btn-comprar").on("click", function () {
        const cantidad = Number($("#prod-cantidad").val());

        if (cantidad < 1) {
          alert("Debe seleccionar una cantidad válida");
          return;
        }

        agregarAlCarrito(p, cantidad);

        alert(`Agregado al carrito: ${cantidad} unidad(es) de "${p.nombre}"`);
      });
    },
    error: function (xhr) {
      console.error("Error cargando producto", xhr.responseText);
      alert("No se pudo cargar la información del producto");
    },
  });
});
