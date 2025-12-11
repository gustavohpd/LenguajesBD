console.log("productosAdmin.js cargado correctamente!");

const API = "http://localhost/LenguajesBD/API/public/index.php";
const ENDPOINT_PRODUCTOS = API + "/api/productos";

$(function () {
  const productoModal = new bootstrap.Modal(
    document.getElementById("productoModal")
  );
  let mode = "create";

  // EVENTOS
  $("#btn-new-product").on("click", openCreate);
  $("#btn-refresh-productos").on("click", loadProductos);
  $("#search-productos").on("input", () =>
    loadProductos($("#search-productos").val())
  );

  $("#productoForm").on("submit", function (e) {
    e.preventDefault();
    mode === "create" ? createProducto() : updateProducto();
  });

  loadProductos();

  /* ---------------- LOAD ---------------- */
  function loadProductos(filter = "") {
    $("#status-productos").text("Cargando productos...");

    $.ajax({
      url: ENDPOINT_PRODUCTOS,
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        const list = Array.isArray(data) ? data : data.data || [];
        renderProductos(list, filter);
        $("#status-productos").text("Productos cargados: " + list.length);
      })
      .fail(() => {
        $("#status-productos").text("Error cargando productos");
      });
  }

  /* ---------------- RENDER ---------------- */
  function renderProductos(list, filter = "") {
    const q = (filter || "").toLowerCase();
    const tbody = $("#productos-tbody").empty();

    const filtered = list.filter(
      (p) =>
        String(p.producto_id).includes(q) ||
        String(p.categoria_id).includes(q) ||
        (p.nombre || "").toLowerCase().includes(q)
    );

    if (filtered.length === 0) {
      tbody.html(
        `<tr><td colspan="7" class="text-center">No hay productos</td></tr>`
      );
      return;
    }

    filtered.forEach((p) =>
      tbody.append(`
        <tr>
          <td>${p.producto_id}</td>
          <td>${p.categoria_id}</td>
          <td>${p.estado_id}</td>
          <td>${p.nombre}</td>
          <td>${p.descripcion || ""}</td>
          <td>₡${Number(p.precio).toFixed(2)}</td>

          <td class="text-end">
            <button class="btn btn-sm btn-info me-1" onclick="editProducto(${
              p.producto_id
            })">Editar</button>
            <button class="btn btn-sm btn-danger" onclick="deleteProducto(${
              p.producto_id
            })">Eliminar</button>
          </td>
        </tr>
      `)
    );
  }

  /* ---------------- READ FORM ---------------- */
  function readForm() {
    const err = $("#producto-form-error").addClass("d-none").text("");

    const id = $("#producto_id").val();
    const categoria = $("#categoria_id").val();
    const estado = $("#estado_id").val();
    const nombre = $("#nombre").val();
    const precio = $("#precio").val();

    if (!id || isNaN(id)) return error("producto_id inválido");
    if (!categoria || isNaN(categoria)) return error("categoria_id inválido");
    if (!nombre) return error("El nombre es obligatorio");
    if (!precio || isNaN(precio)) return error("precio inválido");

    function error(msg) {
      err.removeClass("d-none").text(msg);
      return null;
    }

    return {
      producto_id: Number(id),
      categoria_id: Number(categoria),
      estado_id: Number(estado),
      nombre,
      descripcion: $("#descripcion").val() || "",
      precio: Number(precio),
    };
  }

  /* ---------------- CREATE ---------------- */
  function openCreate() {
    mode = "create";
    $("#productoModalTitle").text("Nuevo Producto");
    $("#productoForm")[0].reset();
    productoModal.show();
  }

  function createProducto() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_PRODUCTOS,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        productoModal.hide();
        loadProductos();
      })
      .fail((xhr) => {
        $("#producto-form-error")
          .removeClass("d-none")
          .text("Error creando producto: " + xhr.responseText);
      });
  }

  /* ---------------- EDIT ---------------- */
  window.editProducto = function (id) {
    mode = "edit";
    $("#status-productos").text("Cargando producto...");

    $.ajax({
      url: ENDPOINT_PRODUCTOS + "/" + id,
      method: "GET",
      dataType: "json",
    })
      .done((p) => {
        p = Array.isArray(p) ? p[0] : p;

        $("#productoModalTitle").text("Editar Producto " + id);

        $("#producto_id").val(p.producto_id);
        $("#categoria_id").val(p.categoria_id);
        $("#estado_id").val(p.estado_id);
        $("#nombre").val(p.nombre);
        $("#descripcion").val(p.descripcion);
        $("#precio").val(p.precio);

        productoModal.show();
      })
      .fail(() => $("#status-productos").text("Error cargando producto"));
  };

  /* ---------------- UPDATE ---------------- */
  function updateProducto() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_PRODUCTOS + "/" + data.producto_id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        productoModal.hide();
        loadProductos();
      })
      .fail((xhr) => {
        $("#producto-form-error")
          .removeClass("d-none")
          .text("Error actualizando producto: " + xhr.responseText);
      });
  }

  /* ---------------- DELETE ---------------- */
  window.deleteProducto = function (id) {
    if (!confirm(`¿Eliminar producto ${id}?`)) return;

    $.ajax({
      url: ENDPOINT_PRODUCTOS + "/" + id,
      method: "DELETE",
    })
      .done(loadProductos)
      .fail(() => alert("Error eliminando producto"));
  };
});
