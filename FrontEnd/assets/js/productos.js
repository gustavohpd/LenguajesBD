$(document).ready(function () {
  // =====================================
  // 1) Variable global para filtrar
  // =====================================
  let productosGlobal = [];

  // =====================================
  // 2) Cargar productos desde la API
  // =====================================
  function cargarProductos() {
    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/productos",
      method: "GET",
      dataType: "json",
      success: function (productos) {
        productosGlobal = productos;
        pintarProductos(productosGlobal);
      },
      error: function (xhr) {
        console.error("Error cargando productos", xhr.responseText);
      },
    });
  }

  // =====================================
  // 3) Pintar productos en pantalla
  // =====================================
  function pintarProductos(productos) {
    let html = "";

    productos.forEach((p) => {
      const descripcionCorta = p.descripcion
        ? p.descripcion.substring(0, 25) + "..."
        : "Sin descripción";

      const imagen =
        p.imagen_url && p.imagen_url.trim() !== ""
          ? p.imagen_url
          : "assets/img/default.png";

      const precioFormateado = `₡${Number(p.precio).toLocaleString("es-CR")}`;

      html += `
        <div class="col-md-4">
          <div class="card mb-4 product-wap rounded-0">
            <div class="card rounded-0">

              <img class="card-img rounded-0 img-fluid"
                src="${imagen}"
                onerror="this.src='assets/img/default.png';">

              <div class="card-img-overlay rounded-0 product-overlay d-flex align-items-center justify-content-center">
                <ul class="list-unstyled">
                  <li>
                    <a class="btn btn-success text-white" href="productoIndv.html?id=${p.producto_id}">
                      <i class="far fa-heart"></i>
                    </a>
                  </li>
                  <li>
                    <a class="btn btn-success text-white mt-2" href="productoIndv.html?id=${p.producto_id}">
                      <i class="far fa-eye"></i>
                    </a>
                  </li>
                  <li>
                    <a class="btn btn-success text-white mt-2" href="productoIndv.html?id=${p.producto_id}">
                      <i class="fas fa-cart-plus"></i>
                    </a>
                  </li>
                </ul>
              </div>
            </div>

            <div class="card-body">
              <a href="productoIndv.html?id=${p.producto_id}" class="h3 text-decoration-none">
                ${p.nombre}
              </a>

              <ul class="w-100 list-unstyled d-flex justify-content-between mb-0">
                <li>${descripcionCorta}</li>
              </ul>

              <p class="text-center mb-0">${precioFormateado}</p>
            </div>
          </div>
        </div>
      `;
    });

    $("#contenedor-productos").html(html);
  }

  // =====================================
  // 4) Filtros Superior (Todo / Facial / Corporal)
  // =====================================
  $(document).on("click", ".filtro-producto", function () {
    const filtro = $(this).data("filtro");
    let filtrados = [];

    if (filtro === "todo") {
      filtrados = productosGlobal;
    } else if (filtro === "facial") {
      filtrados = productosGlobal.filter((p) => p.categoria_id == 1);
    } else if (filtro === "corporal") {
      filtrados = productosGlobal.filter((p) => p.categoria_id == 2);
    }

    pintarProductos(filtrados);

    // ======== MARCAR BOTÓN SELECCIONADO ========
    $(".filtro-producto").removeClass("text-success filtro-activo");
    $(this).addClass("text-success filtro-activo");
  });

  // =====================================
  // 5) Inicializar carga al entrar a la página
  // =====================================
  cargarProductos();
});
