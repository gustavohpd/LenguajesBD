console.log("serviciosAdmin.js cargado");

const API = "http://localhost/LenguajesBD/API/public/index.php";
const ENDPOINT_SERVICIOS = API + "/api/servicios";

$(function () {
  let mode = "create";
  const servicioModal = new bootstrap.Modal(
    document.getElementById("servicioModal")
  );

  $("#btn-new-servicio").on("click", openCreate);
  $("#btn-refresh-servicios").on("click", loadServicios);
  $("#search-servicios").on("input", () =>
    loadServicios($("#search-servicios").val())
  );
  $("#servicioForm").on("submit", (e) => {
    e.preventDefault();
    mode === "create" ? createServicio() : updateServicio();
  });

  loadServicios();

  /* ------------ LOAD ------------ */
  function loadServicios(filter = "") {
    $("#status-servicios").text("Cargando servicios...");

    $.ajax({
      url: ENDPOINT_SERVICIOS,
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        const list = Array.isArray(data) ? data : data.data || [];
        renderServicios(list, filter);
        $("#status-servicios").text(`Servicios cargados: ${list.length}`);
      })
      .fail(() => $("#status-servicios").text("Error cargando servicios"));
  }

  /* ------------ RENDER ------------ */
  function renderServicios(list, filter = "") {
    const q = String(filter).toLowerCase();
    const tbody = $("#servicios-tbody").empty();

    const filtered = list.filter(
      (s) =>
        String(s.servicio_id).includes(q) ||
        String(s.categoria_id).includes(q) ||
        (s.nombre || "").toLowerCase().includes(q)
    );

    if (filtered.length === 0) {
      tbody.html(
        `<tr><td colspan="8" class="text-center">No hay servicios</td></tr>`
      );
      return;
    }

    filtered.forEach((s) => {
      const img = s.imagen_url || "assets/img/default-servicio.png";

      tbody.append(`
        <tr>
          <td>${s.servicio_id}</td>
          <td>${s.categoria_id}</td>
          <td>${s.estado_id}</td>
          <td>${s.nombre}</td>
          <td>${s.duracion}</td>
          <td>${s.precio}</td>
          <td><img src="${img}" style="width:60px;height:60px;object-fit:cover"></td>
          <td class="text-end">
            <button class="btn btn-sm btn-info me-1" onclick="editServicio(${s.servicio_id})">Editar</button>
            <button class="btn btn-sm btn-danger" onclick="deleteServicio(${s.servicio_id})">Eliminar</button>
          </td>
        </tr>
      `);
    });
  }

  /* ------------ FORM ------------ */
  function readForm() {
    const err = $("#servicio-form-error").addClass("d-none").text("");

    const id = $("#servicio_id").val();
    const estado = $("#estado_id").val();
    const categoria = $("#categoria_id").val();
    const nombre = $("#nombre").val();
    const precio = $("#precio").val();

    if (!id) return error("servicio_id es obligatorio");
    if (!categoria) return error("categoria_id es obligatorio");
    if (!nombre) return error("El nombre es obligatorio");
    if (!precio) return error("precio obligatorio");

    function error(msg) {
      err.removeClass("d-none").text(msg);
      return null;
    }

    return {
      servicio_id: Number(id),
      estado_id: Number(estado),
      categoria_id: Number(categoria),
      nombre,
      descripcion: $("#descripcion").val() || "",
      duracion: Number($("#duracion").val()),
      precio: Number(precio),
      imagen_url: $("#imagen_url").val() || "",
    };
  }

  /* ------------ CREATE ------------ */
  function openCreate() {
    mode = "create";
    $("#servicioModalTitle").text("Nuevo Servicio");
    $("#servicioForm")[0].reset();
    $("#servicio-form-error").addClass("d-none");
    servicioModal.show();
  }

  function createServicio() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_SERVICIOS,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        servicioModal.hide();
        loadServicios();
      })
      .fail((xhr) => {
        $("#servicio-form-error")
          .removeClass("d-none")
          .text("Error creando: " + xhr.responseText);
      });
  }

  /* ------------ EDIT ------------ */
  window.editServicio = function (id) {
    mode = "edit";

    $.ajax({
      url: ENDPOINT_SERVICIOS + "/" + id,
      method: "GET",
      dataType: "json",
    })
      .done((s) => {
        $("#servicioModalTitle").text("Editar Servicio");

        $("#servicio_id").val(s.servicio_id);
        $("#estado_id").val(s.estado_id);
        $("#categoria_id").val(s.categoria_id);
        $("#nombre").val(s.nombre);
        $("#descripcion").val(s.descripcion);
        $("#duracion").val(s.duracion);
        $("#precio").val(s.precio);
        $("#imagen_url").val(s.imagen_url);

        servicioModal.show();
      })
      .fail(() => alert("Error cargando servicio"));
  };

  /* ------------ UPDATE ------------ */
  function updateServicio() {
    const data = readForm();
    if (!data) return;

    $.ajax({
      url: ENDPOINT_SERVICIOS + "/" + data.servicio_id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        servicioModal.hide();
        loadServicios();
      })
      .fail((xhr) => {
        $("#servicio-form-error")
          .removeClass("d-none")
          .text("Error actualizando: " + xhr.responseText);
      });
  }

  /* ------------ DELETE ------------ */
  window.deleteServicio = function (id) {
    if (!confirm(`¿Eliminar servicio ${id}?`)) return;

    $.ajax({
      url: ENDPOINT_SERVICIOS + "/" + id,
      method: "DELETE",
    })
      .done(loadServicios)
      .fail(() => alert("Error eliminando servicio"));
  };
});
