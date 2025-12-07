$(document).ready(function () {
  // ============================
  //  CARGAR SERVICIOS
  // ============================
  function cargarServicios() {
    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/servicios",
      method: "GET",
      dataType: "json",
      success: function (data) {
        window.listaServicios = data; // guardar global para filtros
        mostrarServicios(data);
      },
      error: function (xhr) {
        console.error("Error cargando servicios:", xhr.responseText);
      },
    });
  }

  // ============================
  //  RENDER DE SERVICIOS
  // ============================
  function mostrarServicios(lista) {
    let html = "";

    lista.forEach((s) => {
      let precio = `₡${Number(s.precio).toLocaleString("es-CR")}`;

      // Imagen correcta (NO agregar rutas de API)
      const imagen =
        s.imagen_url && s.imagen_url.trim() !== ""
          ? s.imagen_url
          : "assets/img/default-servicio.png";

      html += `
        <div class="col-md-6 col-lg-3 pb-4">
          <div class="h-100 py-4 services-icon-wap shadow text-center">

            <img src="${imagen}"
                 class="img-fluid rounded"
                 style="width:200px;height:200px;object-fit:cover;"
                 onerror="this.src='assets/img/default-servicio.png';">

            <h2 class="h5 mt-3">${s.nombre}</h2>

            <p class="text-muted" style="min-height:60px;">
              ${s.descripcion || ""}
            </p>

            <p class="h5 text-success">${precio}</p>

            <a href="servicioIndividual.html?id=${s.servicio_id}"
               class="btn btn-success mt-2">
               Ver más
            </a>

          </div>
        </div>
      `;
    });

    $("#contenedor-servicios").html(html);
  }

  // ============================
  //  FILTROS POR CATEGORÍA
  // ============================
  $(document).on("click", ".filtro-servicio", function () {
    $(".filtro-servicio").removeClass("text-success fw-bold");
    $(this).addClass("text-success fw-bold");

    const filtro = $(this).data("filtro");

    if (filtro === "todo") {
      mostrarServicios(window.listaServicios);
      return;
    }

    const filtrados = window.listaServicios.filter(
      (s) => s.categoria_id == filtro
    );

    mostrarServicios(filtrados);
  });
  // ==========================================
  // GUARDAR DETALLE DEL SERVICIO ANTES DE VERLO
  // ==========================================
  $(document).on("click", "a[href^='servicioIndividual.html']", function (e) {
    const url = new URL(this.href);
    const id = url.searchParams.get("id");

    if (!window.listaServicios) return;

    const servicioEncontrado = window.listaServicios.find(
      (s) => s.servicio_id == id
    );

    if (servicioEncontrado) {
      localStorage.setItem(
        "servicioDetalle",
        JSON.stringify(servicioEncontrado)
      );
    }
  });

  // ============================
  //  INICIALIZAR
  // ============================
  cargarServicios();
});
