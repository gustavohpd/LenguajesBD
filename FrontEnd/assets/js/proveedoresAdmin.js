console.log("proveedoresAdmin.js cargado correctamente.");

const API = "http://localhost/LenguajesBD/API/public/index.php";
const ENDPOINT_PROVEEDORES = API + "/api/proveedores";

$(function () {
  const proveedorModal = new bootstrap.Modal(
    document.getElementById("proveedorModal")
  );

  let mode = "create"; // create | edit

  $("#btn-new-proveedor").on("click", openCreate);
  $("#btn-refresh-proveedores").on("click", loadProveedores);

  $("#search-proveedores").on("input", () =>
    loadProveedores($("#search-proveedores").val())
  );

  $("#proveedorForm").on("submit", function (e) {
    e.preventDefault();
    mode === "create" ? createProveedor() : updateProveedor();
  });

  loadProveedores();

  /* ================================
       LOAD PROVEEDORES
  =================================*/
  function loadProveedores(filter = "") {
    $("#status-proveedores").text("Cargando proveedores...");

    $.ajax({
      url: ENDPOINT_PROVEEDORES,
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        renderProveedores(data, filter);
        $("#status-proveedores").text("Proveedores cargados: " + data.length);
      })
      .fail(() => $("#status-proveedores").text("Error cargando proveedores"));
  }

  /* ================================
       RENDER TABLE
  =================================*/
  function renderProveedores(list, filter = "") {
    const q = (filter || "").toLowerCase();
    const tbody = $("#proveedores-tbody").empty();

    const filtered = list.filter(
      (p) =>
        String(p.proveedor_id).includes(q) ||
        (p.nombre || "").toLowerCase().includes(q) ||
        (p.contacto || "").toLowerCase().includes(q)
    );

    if (filtered.length === 0) {
      tbody.html(
        `<tr><td colspan="6" class="text-center">No hay proveedores</td></tr>`
      );
      return;
    }

    filtered.forEach((p) => {
      tbody.append(`
        <tr>
          <td>${p.proveedor_id}</td>
          <td>${p.estado_id}</td>
          <td>${p.telefono_id}</td>
          <td>${p.nombre}</td>
          <td>${p.contacto || ""}</td>

          <td class="text-end">
            <button class="btn btn-sm btn-info me-1" onclick="editProveedor(${
              p.proveedor_id
            })">
              Editar
            </button>
            <button class="btn btn-sm btn-danger" onclick="deleteProveedor(${
              p.proveedor_id
            })">
              Eliminar
            </button>
          </td>
        </tr>
      `);
    });
  }

  /* ================================
       FORM VALIDATION
  =================================*/
  function readForm() {
    const err = $("#proveedor-form-error").addClass("d-none").text("");

    const id = Number($("#proveedor_id").val());
    const estado = Number($("#estado_id").val());
    const telefono = Number($("#telefono_id").val());
    const nombre = $("#nombre").val().trim();
    const contacto = $("#contacto").val().trim();

    if (!id || isNaN(id) || id <= 0)
      return error("El proveedor_id debe ser un número válido y mayor que 0.");

    if (!telefono || isNaN(telefono) || telefono <= 0)
      return error("El teléfono_id debe ser un número válido.");

    if (!nombre) return error("El nombre es obligatorio.");

    function error(msg) {
      err.removeClass("d-none").text(msg);
      return null;
    }

    return {
      proveedor_id: id,
      estado_id: estado,
      telefono_id: telefono,
      nombre,
      contacto,
    };
  }

  /* ================================
       CREATE
  =================================*/
  function openCreate() {
    mode = "create";
    $("#proveedorModalTitle").text("Nuevo Proveedor");
    $("#proveedorForm")[0].reset();
    $("#proveedor-form-error").addClass("d-none").text("");
    proveedorModal.show();
  }

  function createProveedor() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_PROVEEDORES,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        proveedorModal.hide();
        loadProveedores();
      })
      .fail((xhr) => {
        $("#proveedor-form-error")
          .removeClass("d-none")
          .text("Error creando proveedor: " + xhr.responseText);
      });
  }

  /* ================================
       EDIT
  =================================*/
  window.editProveedor = function (id) {
    mode = "edit";

    $.ajax({
      url: ENDPOINT_PROVEEDORES + "/" + id,
      method: "GET",
      dataType: "json",
    })
      .done((p) => {
        $("#proveedorModalTitle").text("Editar Proveedor");

        $("#prov_proveedor_id").val(p.proveedor_id);
        $("#prov_estado_id").val(p.estado_id);
        $("#prov_telefono_id").val(p.telefono_id);
        $("#prov_nombre").val(p.nombre);
        $("#prov_contacto").val(p.contacto);

        $("#proveedor-form-error").addClass("d-none").text("");
        proveedorModal.show();
      })
      .fail(() => alert("Error cargando proveedor"));
  };

  /* ================================
       UPDATE
  =================================*/
  function updateProveedor() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_PROVEEDORES + "/" + data.proveedor_id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        proveedorModal.hide();
        loadProveedores();
      })
      .fail((xhr) => {
        $("#proveedor-form-error")
          .removeClass("d-none")
          .text("Error actualizando proveedor: " + xhr.responseText);
      });
  }

  /* ================================
       DELETE
  =================================*/
  window.deleteProveedor = function (id) {
    if (!confirm(`¿Eliminar proveedor ${id}?`)) return;

    $.ajax({
      url: ENDPOINT_PROVEEDORES + "/" + id,
      method: "DELETE",
    })
      .done(loadProveedores)
      .fail(() => alert("Error eliminando proveedor"));
  };
});
