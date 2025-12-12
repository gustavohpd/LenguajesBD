console.log("clientesAdmin.js cargado correctamente!");

const API = "http://localhost/LenguajesBD/API/public/index.php";
const ENDPOINT_CLIENTES = API + "/api/clientes";

$(function () {
  const clienteModal = new bootstrap.Modal(
    document.getElementById("clienteModal")
  );
  let mode = "create";

  // EVENTOS
  $("#btn-new-client").on("click", openCreate);
  $("#btn-refresh-clientes").on("click", loadClientes);
  $("#search-clientes").on("input", () =>
    loadClientes($("#search-clientes").val())
  );

  $("#clienteForm").on("submit", function (e) {
    e.preventDefault();
    mode === "create" ? createCliente() : updateCliente();
  });

  loadClientes();

  /* ---------------- LOAD ---------------- */
  function loadClientes(filter = "") {
    $("#status-clientes").text("Cargando clientes...");

    $.ajax({
      url: ENDPOINT_CLIENTES,
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        const list = Array.isArray(data) ? data : data.data || [];
        renderClientes(list, filter);
        $("#status-clientes").text("Clientes cargados: " + list.length);
      })
      .fail(() => {
        $("#status-clientes").text("Error cargando clientes");
      });
  }

  /* ---------------- RENDER ---------------- */
  function renderClientes(list, filter = "") {
    const q = (filter || "").toLowerCase();
    const tbody = $("#clientes-tbody").empty();

    const filtered = list.filter(
      (c) =>
        String(c.cliente_id).includes(q) ||
        String(c.usuario_id).includes(q) ||
        (c.preferencias || "").toLowerCase().includes(q) ||
        (c.historial || "").toLowerCase().includes(q)
    );

    if (filtered.length === 0) {
      tbody.html(
        `<tr><td colspan="6" class="text-center">No hay clientes</td></tr>`
      );
      return;
    }

    filtered.forEach((c) => {
      tbody.append(`
        <tr>
          <td>${c.cliente_id}</td>
          <td>${c.usuario_id}</td>
          <td>${c.estado_id}</td>
          <td>${c.preferencias || ""}</td>
          <td>${c.historial || ""}</td>
          <td class="text-end">
            <button class="btn btn-sm btn-info me-1" onclick="editCliente(${
              c.cliente_id
            })">Editar</button>
            <button class="btn btn-sm btn-danger" onclick="deleteCliente(${
              c.cliente_id
            })">Eliminar</button>
          </td>
        </tr>
      `);
    });
  }

  /* ---------------- FORM HELPERS ---------------- */
  function readForm() {
    const err = $("#cliente-form-error").addClass("d-none").text("");

    const id = $("#cliente_id").val();
    const usuario = $("#usuario_id").val();
    const estado = $("#estado_id").val();

    if (!id || isNaN(id)) return error("cliente_id inválido");
    if (!usuario || isNaN(usuario)) return error("usuario_id inválido");

    function error(msg) {
      err.removeClass("d-none").text(msg);
      return null;
    }

    return {
      cliente_id: Number(id),
      usuario_id: Number(usuario),
      estado_id: Number(estado),
      preferencias: $("#preferencias").val() || "",
      historial: $("#historial").val() || "", // <- ESTE ES EL CORRECTO
    };
  }

  /* ---------------- CREATE ---------------- */
  function openCreate() {
    mode = "create";
    $("#clienteModalTitle").text("Nuevo Cliente");
    $("#clienteForm")[0].reset();
    $("#cliente-form-error").addClass("d-none");
    clienteModal.show();
  }

  function createCliente() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_CLIENTES,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        clienteModal.hide();
        loadClientes();
      })
      .fail((xhr) => {
        $("#cliente-form-error")
          .removeClass("d-none")
          .text("Error creando cliente: " + xhr.responseText);
      });
  }

  /* ---------------- EDIT ---------------- */
  window.editCliente = function (id) {
    mode = "edit";

    $.ajax({
      url: ENDPOINT_CLIENTES + "/" + id,
      method: "GET",
      dataType: "json",
    })
      .done((c) => {
        c = Array.isArray(c) ? c[0] : c;

        $("#clienteModalTitle").text("Editar Cliente " + id);
        $("#cliente_id").val(c.cliente_id);
        $("#usuario_id").val(c.usuario_id);
        $("#estado_id").val(c.estado_id);
        $("#preferencias").val(c.preferencias);
        $("#historial").val(c.historial);

        clienteModal.show();
      })
      .fail(() => $("#status-clientes").text("Error cargando cliente"));
  };

  /* ---------------- UPDATE ---------------- */
  function updateCliente() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_CLIENTES + "/" + data.cliente_id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        clienteModal.hide();
        loadClientes();
      })
      .fail((xhr) => {
        $("#cliente-form-error")
          .removeClass("d-none")
          .text("Error actualizando cliente: " + xhr.responseText);
      });
  }

  /* ---------------- DELETE ---------------- */
  window.deleteCliente = function (id) {
    if (!confirm(`¿Eliminar cliente ${id}?`)) return;

    $.ajax({
      url: ENDPOINT_CLIENTES + "/" + id,
      method: "DELETE",
    })
      .done(loadClientes)
      .fail(() => alert("Error eliminando cliente"));
  };
});
