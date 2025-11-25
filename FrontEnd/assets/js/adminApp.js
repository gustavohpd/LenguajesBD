/* assets/js/adminApp.js
JQuery: CRUD para Clientes, Servicios y Productos
Endpoints:
- /api/clientes
- /api/servicios
- /api/productos
Nota: siempre se envía el *_id en POST y PUT (validación incluida).
*/
const BASE_API = "http://localhost/LenguajesBD/API/public/index.php";
const ENDPOINT_CLIENTES = BASE_API + "/api/clientes";
const ENDPOINT_SERVICIOS = BASE_API + "/api/servicios";
const ENDPOINT_PRODUCTOS = BASE_API + "/api/productos";

$(function () {
  // Bootstrap modals
  const clienteModal = new bootstrap.Modal(
    document.getElementById("clienteModal")
  );
  const servicioModal = new bootstrap.Modal(
    document.getElementById("servicioModal")
  );
  const productoModal = new bootstrap.Modal(
    document.getElementById("productoModal")
  );

  // Modes
  let clienteMode = "create";
  let servicioMode = "create";
  let productoMode = "create";

  /* ------------------ EVENT BINDING ------------------ */
  // Clientes
  $("#btn-new-client").on("click", openClienteCreate);
  $("#btn-refresh-clientes").on("click", () =>
    loadClientes($("#search-clientes").val())
  );
  $("#search-clientes").on("input", () =>
    loadClientes($("#search-clientes").val())
  );
  $("#clienteForm").on("submit", function (e) {
    e.preventDefault();
    if (clienteMode === "create") createCliente();
    else updateCliente();
  });

  // Servicios
  $("#btn-new-servicio").on("click", openServicioCreate);
  $("#btn-refresh-servicios").on("click", () =>
    loadServicios($("#search-servicios").val())
  );
  $("#search-servicios").on("input", () =>
    loadServicios($("#search-servicios").val())
  );
  $("#servicioForm").on("submit", function (e) {
    e.preventDefault();
    if (servicioMode === "create") createServicio();
    else updateServicio();
  });

  // Productos
  $("#btn-new-producto").on("click", openProductoCreate);
  $("#btn-refresh-productos").on("click", () =>
    loadProductos($("#search-productos").val())
  );
  $("#search-productos").on("input", () =>
    loadProductos($("#search-productos").val())
  );
  $("#productoForm").on("submit", function (e) {
    e.preventDefault();
    if (productoMode === "create") createProducto();
    else updateProducto();
  });

  // Initial load
  loadClientes();
  loadServicios();
  loadProductos();

  /* ------------------ CLIENTES ------------------ */
  function setStatusClientes(txt) {
    $("#status-clientes").text("Estado: " + txt);
  }
  function showClienteError(msg) {
    $("#cliente-form-error").removeClass("d-none").text(msg);
  }

  function loadClientes(filter = "") {
    setStatusClientes("Cargando clientes...");
    $.ajax({ url: ENDPOINT_CLIENTES, method: "GET", dataType: "json" })
      .done((data) => {
        const list = Array.isArray(data) ? data : data.data || [];
        renderClientes(list, filter);
        setStatusClientes("Clientes cargados: " + list.length);
      })
      .fail((xhr) => {
        setStatusClientes(
          "Error al cargar clientes: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        );
        $("#clientes-tbody").html(
          '<tr><td colspan="6" class="text-center">No se pudo cargar la lista</td></tr>'
        );
      });
  }

  function renderClientes(list, filter = "") {
    const q = (filter || "").toLowerCase();
    const tbody = $("#clientes-tbody").empty();
    const filtered = list.filter((c) => {
      if (!q) return true;
      return (
        String(c.cliente_id).includes(q) ||
        String(c.usuario_id).includes(q) ||
        (c.preferencias || "").toLowerCase().includes(q) ||
        (c.historial || "").toLowerCase().includes(q)
      );
    });
    if (filtered.length === 0) {
      tbody.html(
        '<tr><td colspan="6" class="text-center">No hay clientes</td></tr>'
      );
      return;
    }
    filtered.forEach((c) => {
      const $tr = $("<tr>");
      $tr.append($("<td>").text(c.cliente_id));
      $tr.append($("<td>").text(c.usuario_id));
      $tr.append($("<td>").text(c.estado_id));
      $tr.append($("<td>").text(c.preferencias || ""));
      $tr.append($("<td>").text(c.historial || ""));
      const $actions = $('<td class="text-end">');
      $actions.append(
        $('<button class="btn btn-sm btn-info me-1">Editar</button>').on(
          "click",
          () => openClienteEdit(c.cliente_id)
        )
      );
      $actions.append(
        $('<button class="btn btn-sm btn-danger">Eliminar</button>').on(
          "click",
          () => confirmDeleteCliente(c.cliente_id)
        )
      );
      $tr.append($actions);
      tbody.append($tr);
    });
  }

  function openClienteCreate() {
    clienteMode = "create";
    $("#clienteModalTitle").text("Nuevo cliente");
    $("#clienteForm")[0].reset();
    $("#cliente_id").val("");
    $("#cliente-form-error").addClass("d-none").text("");
    clienteModal.show();
  }

  function openClienteEdit(id) {
    clienteMode = "edit";
    setStatusClientes("Cargando cliente " + id + "...");
    $.ajax({
      url: ENDPOINT_CLIENTES + "/" + encodeURIComponent(id),
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        const c = Array.isArray(data) ? data[0] : data.data || data;
        if (!c) {
          setStatusClientes("Cliente no encontrado");
          return;
        }
        $("#clienteModalTitle").text("Editar cliente " + id);
        $("#cliente_id").val(c.cliente_id || "");
        $("#usuario_id").val(c.usuario_id || "");
        $("#estado_id").val(c.estado_id || 1);
        $("#preferencias").val(c.preferencias || "");
        $("#historial").val(c.historial || "");
        $("#cliente-form-error").addClass("d-none").text("");
        clienteModal.show();
        setStatusClientes("Cliente cargado");
      })
      .fail((xhr) =>
        setStatusClientes(
          "Error cargando cliente: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function validateInteger(val, name, $err) {
    if (val === "" || val === null || val === undefined) {
      $err
        .removeClass("d-none")
        .text(name + " es obligatorio y debe ser entero");
      return false;
    }
    if (!/^\d+$/.test(String(val))) {
      $err.removeClass("d-none").text(name + " debe ser un número entero");
      return false;
    }
    return true;
  }

  function readClienteFormAlwaysSendId() {
    $("#cliente-form-error").addClass("d-none").text("");
    const clienteId = $("#cliente_id").val();
    const usuarioId = $("#usuario_id").val();
    const estadoId = $("#estado_id").val();
    if (!validateInteger(clienteId, "cliente_id", $("#cliente-form-error")))
      return null;
    if (!validateInteger(usuarioId, "usuario_id", $("#cliente-form-error")))
      return null;
    if (!validateInteger(estadoId, "estado_id", $("#cliente-form-error")))
      return null;
    return {
      cliente_id: Number(clienteId),
      usuario_id: Number(usuarioId),
      estado_id: Number(estadoId),
      preferencias: $("#preferencias").val() || "",
      historial: $("#historial").val() || "",
    };
  }

  function createCliente() {
    const payload = readClienteFormAlwaysSendId();
    if (payload === null) return;
    setStatusClientes("Creando cliente...");
    $.ajax({
      url: ENDPOINT_CLIENTES,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      dataType: "json",
    })
      .done(() => {
        clienteModal.hide();
        loadClientes();
        setStatusClientes("Cliente creado");
      })
      .fail((xhr) =>
        showClienteError(
          "Error creando cliente: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function updateCliente() {
    const payload = readClienteFormAlwaysSendId();
    if (payload === null) return;
    const id = payload.cliente_id;
    setStatusClientes("Actualizando cliente " + id + "...");
    $.ajax({
      url: ENDPOINT_CLIENTES + "/" + encodeURIComponent(id),
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(payload),
      dataType: "json",
    })
      .done(() => {
        clienteModal.hide();
        loadClientes();
        setStatusClientes("Cliente actualizado");
      })
      .fail((xhr) =>
        showClienteError(
          "Error actualizando: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function confirmDeleteCliente(id) {
    if (!confirm("¿Eliminar cliente " + id + " ?")) return;
    $.ajax({
      url: ENDPOINT_CLIENTES + "/" + encodeURIComponent(id),
      method: "DELETE",
      dataType: "json",
    })
      .done(() => {
        loadClientes();
        setStatusClientes("Cliente eliminado");
      })
      .fail((xhr) =>
        setStatusClientes(
          "Error al eliminar: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  /* ------------------ SERVICIOS ------------------ */
  function setStatusServicios(txt) {
    $("#status-servicios").text("Estado: " + txt);
  }
  function showServicioError(msg) {
    $("#servicio-form-error").removeClass("d-none").text(msg);
  }

  function loadServicios(filter = "") {
    setStatusServicios("Cargando servicios...");
    $.ajax({ url: ENDPOINT_SERVICIOS, method: "GET", dataType: "json" })
      .done((data) => {
        const list = Array.isArray(data) ? data : data.data || [];
        renderServicios(list, filter);
        setStatusServicios("Servicios cargados: " + list.length);
      })
      .fail((xhr) => {
        setStatusServicios(
          "Error al cargar servicios: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        );
        $("#servicios-tbody").html(
          '<tr><td colspan="6" class="text-center">No se pudo cargar la lista</td></tr>'
        );
      });
  }

  function renderServicios(list, filter = "") {
    const q = (filter || "").toLowerCase();
    const tbody = $("#servicios-tbody").empty();
    const filtered = list.filter((s) => {
      if (!q) return true;
      return (
        String(s.servicio_id).includes(q) ||
        (s.nombre || "").toLowerCase().includes(q) ||
        String(s.categoria_id).includes(q)
      );
    });
    if (filtered.length === 0) {
      tbody.html(
        '<tr><td colspan="6" class="text-center">No hay servicios</td></tr>'
      );
      return;
    }
    filtered.forEach((s) => {
      const $tr = $("<tr>");
      $tr.append($("<td>").text(s.servicio_id));
      $tr.append($("<td>").text(s.categoria_id));
      $tr.append($("<td>").text(s.nombre));
      $tr.append($("<td>").text(s.duracion));
      $tr.append($("<td>").text(s.precio));
      const $actions = $('<td class="text-end">');
      $actions.append(
        $('<button class="btn btn-sm btn-info me-1">Editar</button>').on(
          "click",
          () => openServicioEdit(s.servicio_id)
        )
      );
      $actions.append(
        $('<button class="btn btn-sm btn-danger">Eliminar</button>').on(
          "click",
          () => confirmDeleteServicio(s.servicio_id)
        )
      );
      $tr.append($actions);
      tbody.append($tr);
    });
  }

  function openServicioCreate() {
    servicioMode = "create";
    $("#servicioModalTitle").text("Nuevo servicio");
    $("#servicioForm")[0].reset();
    $("#servicio_id").val("");
    $("#servicio-form-error").addClass("d-none").text("");
    servicioModal.show();
  }

  function openServicioEdit(id) {
    servicioMode = "edit";
    setStatusServicios("Cargando servicio " + id + "...");
    $.ajax({
      url: ENDPOINT_SERVICIOS + "/" + encodeURIComponent(id),
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        const s = Array.isArray(data) ? data[0] : data.data || data;
        if (!s) {
          setStatusServicios("Servicio no encontrado");
          return;
        }
        $("#servicioModalTitle").text("Editar servicio " + id);
        $("#servicio_id").val(s.servicio_id || "");
        $("#servicio_estado_id").val(s.estado_id || 1);
        $("#categoria_id").val(s.categoria_id || 1);
        $("#nombre").val(s.nombre || "");
        $("#descripcion").val(s.descripcion || "");
        $("#duracion").val(s.duracion || 60);
        $("#precio").val(s.precio || 0);
        $("#servicio-form-error").addClass("d-none").text("");
        servicioModal.show();
        setStatusServicios("Servicio cargado");
      })
      .fail((xhr) =>
        setStatusServicios(
          "Error cargando servicio: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function readServicioFormAlwaysSendId() {
    $("#servicio-form-error").addClass("d-none").text("");
    const sid = $("#servicio_id").val();
    const est = $("#servicio_estado_id").val();
    const cat = $("#categoria_id").val();
    const dur = $("#duracion").val();
    const precio = $("#precio").val();
    if (!validateInteger(sid, "servicio_id", $("#servicio-form-error")))
      return null;
    if (!validateInteger(est, "estado_id", $("#servicio-form-error")))
      return null;
    if (!validateInteger(cat, "categoria_id", $("#servicio-form-error")))
      return null;
    if (!validateInteger(dur, "duracion", $("#servicio-form-error")))
      return null;
    if (precio === "" || isNaN(Number(precio))) {
      $("#servicio-form-error")
        .removeClass("d-none")
        .text("precio debe ser un número");
      return null;
    }
    return {
      servicio_id: Number(sid),
      estado_id: Number(est),
      categoria_id: Number(cat),
      nombre: $("#nombre").val() || "",
      descripcion: $("#descripcion").val() || "",
      duracion: Number(dur),
      precio: Number(precio),
    };
  }

  function createServicio() {
    const payload = readServicioFormAlwaysSendId();
    if (payload === null) return;
    setStatusServicios("Creando servicio...");
    $.ajax({
      url: ENDPOINT_SERVICIOS,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      dataType: "json",
    })
      .done(() => {
        servicioModal.hide();
        loadServicios();
        setStatusServicios("Servicio creado");
      })
      .fail((xhr) =>
        showServicioError(
          "Error creando servicio: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function updateServicio() {
    const payload = readServicioFormAlwaysSendId();
    if (payload === null) return;
    const id = payload.servicio_id;
    setStatusServicios("Actualizando servicio " + id + "...");
    $.ajax({
      url: ENDPOINT_SERVICIOS + "/" + encodeURIComponent(id),
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(payload),
      dataType: "json",
    })
      .done(() => {
        servicioModal.hide();
        loadServicios();
        setStatusServicios("Servicio actualizado");
      })
      .fail((xhr) =>
        showServicioError(
          "Error actualizando servicio: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function confirmDeleteServicio(id) {
    if (!confirm("¿Eliminar servicio " + id + " ?")) return;
    $.ajax({
      url: ENDPOINT_SERVICIOS + "/" + encodeURIComponent(id),
      method: "DELETE",
      dataType: "json",
    })
      .done(() => {
        loadServicios();
        setStatusServicios("Servicio eliminado");
      })
      .fail((xhr) =>
        setStatusServicios(
          "Error al eliminar: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  /* ------------------ PRODUCTOS ------------------ */
  function setStatusProductos(txt) {
    $("#status-productos").text("Estado: " + txt);
  }
  function showProductoError(msg) {
    $("#producto-form-error").removeClass("d-none").text(msg);
  }

  function loadProductos(filter = "") {
    setStatusProductos("Cargando productos...");
    $.ajax({ url: ENDPOINT_PRODUCTOS, method: "GET", dataType: "json" })
      .done((data) => {
        const list = Array.isArray(data) ? data : data.data || [];
        renderProductos(list, filter);
        setStatusProductos("Productos cargados: " + list.length);
      })
      .fail((xhr) => {
        setStatusProductos(
          "Error al cargar productos: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        );
        $("#productos-tbody").html(
          '<tr><td colspan="7" class="text-center">No se pudo cargar la lista</td></tr>'
        );
      });
  }

  function renderProductos(list, filter = "") {
    const q = (filter || "").toLowerCase();
    const tbody = $("#productos-tbody").empty();
    const filtered = list.filter((p) => {
      if (!q) return true;
      return (
        String(p.producto_id).includes(q) ||
        (p.nombre || "").toLowerCase().includes(q) ||
        String(p.categoria_id).includes(q)
      );
    });
    if (filtered.length === 0) {
      tbody.html(
        '<tr><td colspan="7" class="text-center">No hay productos</td></tr>'
      );
      return;
    }
    filtered.forEach((p) => {
      const $tr = $("<tr>");
      $tr.append($("<td>").text(p.producto_id));
      $tr.append($("<td>").text(p.categoria_id));
      $tr.append($("<td>").text(p.estado_id));
      $tr.append($("<td>").text(p.proveedor_id));
      $tr.append($("<td>").text(p.nombre));
      $tr.append($("<td>").text(p.precio));
      const $actions = $('<td class="text-end">');
      $actions.append(
        $('<button class="btn btn-sm btn-info me-1">Editar</button>').on(
          "click",
          () => openProductoEdit(p.producto_id)
        )
      );
      $actions.append(
        $('<button class="btn btn-sm btn-danger">Eliminar</button>').on(
          "click",
          () => confirmDeleteProducto(p.producto_id)
        )
      );
      $tr.append($actions);
      tbody.append($tr);
    });
  }

  function openProductoCreate() {
    productoMode = "create";
    $("#productoModalTitle").text("Nuevo producto");
    $("#productoForm")[0].reset();
    $("#producto_id").val("");
    $("#producto-form-error").addClass("d-none").text("");
    productoModal.show();
  }

  function openProductoEdit(id) {
    productoMode = "edit";
    setStatusProductos("Cargando producto " + id + "...");
    $.ajax({
      url: ENDPOINT_PRODUCTOS + "/" + encodeURIComponent(id),
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        const p = Array.isArray(data) ? data[0] : data.data || data;
        if (!p) {
          setStatusProductos("Producto no encontrado");
          return;
        }
        $("#productoModalTitle").text("Editar producto " + id);
        $("#producto_id").val(p.producto_id || "");
        $("#producto_categoria_id").val(p.categoria_id || 1);
        $("#producto_estado_id").val(p.estado_id || 1);
        $("#proveedor_id").val(p.proveedor_id || 1);
        $("#producto_nombre").val(p.nombre || "");
        $("#producto_descripcion").val(p.descripcion || "");
        $("#producto_precio").val(p.precio || 0);
        $("#producto-form-error").addClass("d-none").text("");
        productoModal.show();
        setStatusProductos("Producto cargado");
      })
      .fail((xhr) =>
        setStatusProductos(
          "Error cargando producto: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function readProductoFormAlwaysSendId() {
    $("#producto-form-error").addClass("d-none").text("");
    const pid = $("#producto_id").val();
    const cat = $("#producto_categoria_id").val();
    const est = $("#producto_estado_id").val();
    const prov = $("#proveedor_id").val();
    const precio = $("#producto_precio").val();

    if (!validateInteger(pid, "producto_id", $("#producto-form-error")))
      return null;
    if (!validateInteger(cat, "categoria_id", $("#producto-form-error")))
      return null;
    if (!validateInteger(est, "estado_id", $("#producto-form-error")))
      return null;
    if (!validateInteger(prov, "proveedor_id", $("#producto-form-error")))
      return null;
    if (precio === "" || isNaN(Number(precio))) {
      $("#producto-form-error")
        .removeClass("d-none")
        .text("precio debe ser un número");
      return null;
    }

    return {
      producto_id: Number(pid),
      categoria_id: Number(cat),
      estado_id: Number(est),
      proveedor_id: Number(prov),
      nombre: $("#producto_nombre").val() || "",
      descripcion: $("#producto_descripcion").val() || "",
      precio: Number(precio),
    };
  }

  function createProducto() {
    const payload = readProductoFormAlwaysSendId();
    if (payload === null) return;
    setStatusProductos("Creando producto...");
    $.ajax({
      url: ENDPOINT_PRODUCTOS,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      dataType: "json",
    })
      .done(() => {
        productoModal.hide();
        loadProductos();
        setStatusProductos("Producto creado");
      })
      .fail((xhr) =>
        showProductoError(
          "Error creando producto: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function updateProducto() {
    const payload = readProductoFormAlwaysSendId();
    if (payload === null) return;
    const id = payload.producto_id;
    setStatusProductos("Actualizando producto " + id + "...");
    $.ajax({
      url: ENDPOINT_PRODUCTOS + "/" + encodeURIComponent(id),
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(payload),
      dataType: "json",
    })
      .done(() => {
        productoModal.hide();
        loadProductos();
        setStatusProductos("Producto actualizado");
      })
      .fail((xhr) =>
        showProductoError(
          "Error actualizando producto: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }

  function confirmDeleteProducto(id) {
    if (!confirm("¿Eliminar producto " + id + " ?")) return;
    $.ajax({
      url: ENDPOINT_PRODUCTOS + "/" + encodeURIComponent(id),
      method: "DELETE",
      dataType: "json",
    })
      .done(() => {
        loadProductos();
        setStatusProductos("Producto eliminado");
      })
      .fail((xhr) =>
        setStatusProductos(
          "Error al eliminar: " +
            (xhr.responseJSON?.message || xhr.statusText || xhr.status)
        )
      );
  }
});

$('#clienteModal').on('hidden.bs.modal', function () {
    $('#openModalButton').focus(); // move focus back to trigger
});

$('#servicioModal').on('hidden.bs.modal', function () {
    $('#openServicioModalButton').focus(); // move focus back to trigger
});

$('#productoModal').on('hidden.bs.modal', function () {
    $('#openProductoModalButton').focus(); // return focus to trigger
});