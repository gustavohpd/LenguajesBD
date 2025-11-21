// ---------------------------
// CONFIG
// ---------------------------
const API_BASE = "http://localhost/LenguajesBD/API/public/index.php"; // ajusta si necesitas

// helpers de UI
function showAlert(msg, type = "success", timeout = 3500) {
  const id = "a" + Date.now();
  const html = `<div id="${id}" class="alert alert-${type} alert-dismissible fade show mx-3" role="alert">
            ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>`;
  $("#alertPlaceholder").append(html);
  if (timeout) setTimeout(() => $(`#${id}`).alert("close"), timeout);
}

// ---------------------------
// DOCUMENT READY
// ---------------------------
$(function () {
  // Cargar listas
  cargarClientes();
  cargarServicios();
  cargarProductos();

  // Abrir modales
  $("#btnAgregarCliente").click(() => abrirModalCliente("create"));
  $("#btnAgregarServicio").click(() => abrirModalServicio("create"));
  $("#btnAgregarProducto").click(() => abrirModalProducto("create"));

  // Submit formularios
  $("#formCliente").submit(submitFormCliente);
  $("#formServicio").submit(submitFormServicio);
  $("#formProducto").submit(submitFormProducto);

  // Delegación: botones editar y eliminar para cada tabla
  $("#tablaClientes").on("click", ".edit-cliente", function () {
    const id = $(this).data("id");
    abrirModalCliente("edit", id);
  });
  $("#tablaClientes").on("click", ".delete-cliente", function () {
    const id = $(this).data("id");
    confirmarEliminar("cliente", id);
  });

  $("#tablaServicios").on("click", ".edit-servicio", function () {
    const id = $(this).data("id");
    abrirModalServicio("edit", id);
  });
  $("#tablaServicios").on("click", ".delete-servicio", function () {
    const id = $(this).data("id");
    confirmarEliminar("servicio", id);
  });

  $("#tablaProductos").on("click", ".edit-producto", function () {
    const id = $(this).data("id");
    abrirModalProducto("edit", id);
  });
  $("#tablaProductos").on("click", ".delete-producto", function () {
    const id = $(this).data("id");
    confirmarEliminar("producto", id);
  });
});

// ---------------------------
// CARGAR LISTAS (READ)
// ---------------------------
function cargarClientes() {
  $.ajax({
    url: API_BASE + "/api/clientes",
    method: "GET",
    dataType: "json",
    success: function (data) {
      let rows = "";
      (data || []).forEach((c) => {
        rows += `<tr>
                        <td>${c.cliente_id}</td>
                        <td>${c.usuario_id}</td>
                        <td>${c.estado_id}</td>
                        <td>${escapeHtml(c.preferencias || "")}</td>
                        <td>${escapeHtml(c.historial_tratamientos || "")}</td>
                        <td>
                            <button class="btn btn-sm btn-info edit-cliente" data-id="${
                              c.cliente_id
                            }"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-danger delete-cliente" data-id="${
                              c.cliente_id
                            }"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>`;
      });
      $("#tablaClientes tbody").html(rows);
    },
    error: function (xhr) {
      showAlert("No se pudieron cargar clientes.", "danger");
      console.error(xhr);
    },
  });
}

function cargarServicios() {
  $.ajax({
    url: API_BASE + "/api/servicios",
    method: "GET",
    dataType: "json",
    success: function (data) {
      let rows = "";
      (data || []).forEach((s) => {
        rows += `<tr>
                        <td>${s.servicio_id}</td>
                        <td>${s.estado_id}</td>
                        <td>${s.categoria_id}</td>
                        <td>${escapeHtml(s.nombre || "")}</td>
                        <td>${escapeHtml(s.descripcion || "")}</td>
                        <td>${s.duracion ? s.duracion + " min" : ""}</td>
                        <td>${s.precio || ""}</td>
                        <td>
                            <button class="btn btn-sm btn-info edit-servicio" data-id="${
                              s.servicio_id
                            }"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-danger delete-servicio" data-id="${
                              s.servicio_id
                            }"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>`;
      });
      $("#tablaServicios tbody").html(rows);
    },
    error: function (xhr) {
      showAlert("No se pudieron cargar servicios.", "danger");
      console.error(xhr);
    },
  });
}

function cargarProductos() {
  $.ajax({
    url: API_BASE + "/api/productos",
    method: "GET",
    dataType: "json",
    success: function (data) {
      let rows = "";
      (data || []).forEach((p) => {
        rows += `<tr>
                        <td>${p.producto_id}</td>
                        <td>${p.categoria_id}</td>
                        <td>${p.estado_id}</td>
                        <td>${escapeHtml(p.proveedor_id || "")}</td>
                        <td>${escapeHtml(p.nombre || "")}</td>
                        <td>${escapeHtml(p.descripcion || "")}</td>
                        <td>${p.precio || ""}</td>
                        <td>
                            <button class="btn btn-sm btn-info edit-producto" data-id="${
                              p.producto_id
                            }"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-danger delete-producto" data-id="${
                              p.producto_id
                            }"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>`;
      });
      $("#tablaProductos tbody").html(rows);
    },
    error: function (xhr) {
      showAlert("No se pudieron cargar productos.", "danger");
      console.error(xhr);
    },
  });
}

// ---------------------------
// MODALES: abrir y precargar
// ---------------------------
function abrirModalCliente(mode, id) {
  const modalEl = new bootstrap.Modal(document.getElementById("modalCliente"));
  $("#formCliente")[0].reset();
  $("#isCreate").val("");
  if (mode === "create") {
    $("#isCreate").val(1);
    $("#modalClienteTitle").text("Nuevo Cliente");
    $("#estado_id").val("1");
    modalEl.show();
  } else {
    $("#modalClienteTitle").text("Editar Cliente");
    // cargar por id
    $.ajax({
      url: API_BASE + "/api/clientes/" + id,
      method: "GET",
      dataType: "json",
      success: function (c) {
        $("#cliente_id").val(c.cliente_id);
        $("#usuario_id").val(c.usuario_id);
        $("#estado_id").val(c.estado_id);
        $("#preferencias").val(c.preferencias);
        $("#historial_tratamientos").val(c.historial_tratamientos);
        modalEl.show();
      },
      error: function () {
        showAlert("No se pudo obtener el cliente.", "danger");
      },
    });
  }
}

function abrirModalProducto(mode, id) {
  const modalEl = new bootstrap.Modal(document.getElementById("modalProducto"));
  $("#formServicio")[0].reset();
  $("#isCreate").val("");
  if (mode === "create") {
    $("#isCreate").val(1);
    $("#modalProductoTitle").text("Nuevo Producto");
    $("#producto_id").val("1");
    modalEl.show();
  } else {
    $("#modalProductoTitle").text("Editar Producto");
    $.ajax({
      url: API_BASE + "/api/productos/" + id,
      method: "GET",
      dataType: "json",
      success: function (s) {
        $("#producto_id").val(s.producto_id);
        $("#categoria_id_prod").val(s.categoria_id);
        $("#prod_estado_id").val(s.estado_id);
        $("#proveedor_id").val(s.proveedor_id);
        $("#prod_nombre").val(s.nombre);
        $("#prod_descripcion").val(s.descripcion);
        $("#prod_precio").val(s.precio);
        modalEl.show();
      },
      error: function () {
        showAlert("No se pudo obtener el servicio.", "danger");
      },
    });
  }
}

function abrirModalServicio(mode, id) {
  const modalEl = new bootstrap.Modal(document.getElementById("modalServicio"));
  $("#formServicio")[0].reset();
  $("#isCreate").val("");
  if (mode === "create") {
    $("#modalServicioTitle").text("Nuevo Servicio");
    $("#serv_estado_id").val("1");
    modalEl.show();
  } else {
    $("#modalServicioTitle").text("Editar Servicio");
    $.ajax({
      url: API_BASE + "/api/servicios/" + id,
      method: "GET",
      dataType: "json",
      success: function (s) {
        $("#servicio_id").val(s.servicio_id);
        $("#serv_estado_id").val(s.estado_id);
        $("#categoria_id_serv").val(s.categoria_id);
        $("#serv_nombre").val(s.nombre);
        $("#serv_descripcion").val(s.descripcion);
        $("#duracion").val(s.duracion);
        $("#serv_precio").val(s.precio);
        modalEl.show();
      },
      error: function () {
        showAlert("No se pudo obtener el servicio.", "danger");
      },
    });
  }
}

function submitFormCliente(e) {
  e.preventDefault();

  // Siempre tomamos cliente_id del input
  const isCreate = $("#isCreate").val();
  const id = $("#cliente_id").val();

  const payload = {
    cliente_id: parseInt($("#cliente_id").val()), // requerido incluso para POST
    usuario_id: parseInt($("#usuario_id").val()),
    estado_id: parseInt($("#estado_id").val()),
    preferencias: $("#preferencias").val(),
    historial: $("#historial_tratamientos").val(),
  };

  if (!payload.cliente_id || !payload.usuario_id) {
    showAlert("Cliente ID y Usuario ID son obligatorios.", "warning");
    return;
  }
  if (!isCreate) {
    console.log("PUT", isCreate);
    $.ajax({
      url: API_BASE + "/api/clientes/" + id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function () {
        bootstrap.Modal.getInstance(
          document.getElementById("modalCliente")
        ).hide();
        showAlert("Cliente actualizado.", "success");
        cargarServicios();
      },
      error: function () {
        showAlert("Error al actualizar Cliente.", "danger");
      },
    });
  } else {
    console.log("POST", isCreate);
    $.ajax({
      url: API_BASE + "/api/clientes",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function () {
        bootstrap.Modal.getInstance(
          document.getElementById("modalCliente")
        ).hide();
        showAlert("Cliente creado.", "success");
        cargarServicios();
      },
      error: function () {
        showAlert("Error al crear cliente.", "danger");
      },
    });
  }
}

// ---------------------------
// SUBMITS (CREATE / UPDATE)
// ---------------------------

function submitFormServicio(e) {
  e.preventDefault();
  const id = $("#servicio_id").val();
  const payload = {
    estado_id: $("#serv_estado_id").val(),
    categoria_id: $("#categoria_id_serv").val(),
    nombre: $("#serv_nombre").val(),
    descripcion: $("#serv_descripcion").val(),
    duracion: $("#duracion").val(),
    precio: $("#serv_precio").val(),
  };

  if (!payload.nombre) {
    showAlert("Nombre del servicio es obligatorio.", "warning");
    return;
  }

  if (id) {
    $.ajax({
      url: API_BASE + "/api/servicios/" + id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function () {
        bootstrap.Modal.getInstance(
          document.getElementById("modalServicio")
        ).hide();
        showAlert("Servicio actualizado.", "success");
        cargarServicios();
      },
      error: function () {
        showAlert("Error al actualizar servicio.", "danger");
      },
    });
  } else {
    $.ajax({
      url: API_BASE + "/api/servicios",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function () {
        bootstrap.Modal.getInstance(
          document.getElementById("modalServicio")
        ).hide();
        showAlert("Servicio creado.", "success");
        cargarServicios();
      },
      error: function () {
        showAlert("Error al crear servicio.", "danger");
      },
    });
  }
}

function submitFormProducto(e) {
  e.preventDefault();
  const isCreate = $("#isCreate").val();
  const id = $("#producto_id").val();
  const payload = {
    producto_id: parseInt($("#producto_id").val()),
    categoria_id: parseInt($("#categoria_id_prod").val()),
    estado_id: parseInt($("#prod_estado_id").val()),
    proveedor_id: parseInt($("#proveedor_id").val()),
    nombre: $("#prod_nombre").val(),
    descripcion: $("#prod_descripcion").val(),
    precio: parseInt($("#prod_precio").val()),
  };

  if (!payload.nombre) {
    showAlert("Nombre del producto es obligatorio.", "warning");
    return;
  }

  if (!isCreate) {
    $.ajax({
      url: API_BASE + "/api/productos/" + id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function () {
        bootstrap.Modal.getInstance(
          document.getElementById("modalProducto")
        ).hide();
        showAlert("Producto actualizado.", "success");
        cargarProductos();
      },
      error: function () {
        showAlert("Error al actualizar producto.", "danger");
      },
    });
  } else {
    $.ajax({
      url: API_BASE + "/api/productos",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function () {
        bootstrap.Modal.getInstance(
          document.getElementById("modalProducto")
        ).hide();
        showAlert("Producto creado.", "success");
        cargarProductos();
      },
      error: function () {
        showAlert("Error al crear producto.", "danger");
      },
    });
  }
}

// ---------------------------
// ELIMINAR (DELETE) -> cambia estado a 2 en el backend
// ---------------------------
function confirmarEliminar(tipo, id) {
  const ok = confirm(
    "¿Confirmar eliminar? (esto ejecutará un DELETE que en tu API cambia estado a 2)"
  );
  if (!ok) return;

  let url = API_BASE;
  if (tipo === "cliente") url += "/api/clientes/" + id;
  if (tipo === "servicio") url += "/api/servicios/" + id;
  if (tipo === "producto") url += "/api/productos/" + id;

  $.ajax({
    url: url,
    method: "DELETE",
    success: function () {
      showAlert("Eliminado correctamente (estado actualizado).", "success");
      // recargar tabla correspondiente
      if (tipo === "cliente") cargarClientes();
      if (tipo === "servicio") cargarServicios();
      if (tipo === "producto") cargarProductos();
    },
    error: function () {
      showAlert("Error al eliminar.", "danger");
    },
  });
}

// ---------------------------
// UTILIDADES
// ---------------------------
function escapeHtml(unsafe) {
  return String(unsafe)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
