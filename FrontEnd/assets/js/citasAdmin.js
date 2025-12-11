console.log("citasAdmin.js cargado correctamente.");

const API = "http://localhost/LenguajesBD/API/public/index.php";
const ENDPOINT_CITAS = API + "/api/citas";

$(function () {
  const citaModal = new bootstrap.Modal(document.getElementById("citaModal"));
  let mode = "edit";

  $("#btn-refresh-citas").on("click", loadCitas);
  $("#search-citas").on("input", () => loadCitas($("#search-citas").val()));

  $("#citaForm").on("submit", function (e) {
    e.preventDefault();
    updateCita();
  });

  loadCitas();

  /* ---------------- LOAD ---------------- */
  function loadCitas(filter = "") {
    $("#status-citas").text("Cargando citas...");

    $.ajax({
      url: ENDPOINT_CITAS,
      method: "GET",
      dataType: "json",
    })
      .done((data) => {
        renderCitas(data, filter);
        $("#status-citas").text(`Citas cargadas: ${data.length}`);
      })
      .fail(() => $("#status-citas").text("Error cargando citas"));
  }

  /* ---------------- RENDER ---------------- */
  function renderCitas(list, filter = "") {
    const q = filter?.toLowerCase() ?? "";
    const tbody = $("#citas-tbody").empty();

    const filtered = list.filter(
      (c) =>
        String(c.cita_id).includes(q) ||
        String(c.cliente_id).includes(q) ||
        (c.servicio_nombre || "").toLowerCase().includes(q)
    );

    if (filtered.length === 0) {
      tbody.html(
        `<tr><td colspan="7" class="text-center">No hay citas</td></tr>`
      );
      return;
    }

    filtered.forEach((c) => {
      const fecha = c.fecha_hora.replace("T", " ").substring(0, 16);

      tbody.append(`
        <tr>
          <td>${c.cita_id}</td>
          <td>${c.cliente_id}</td>
          <td>${c.servicio_nombre || c.servicio_id}</td>
          <td>${c.nombre_estado || c.estado_id}</td>
          <td>${fecha}</td>
          <td>${c.notas || ""}</td>

          <td class="text-end">
            <button class="btn btn-sm btn-info me-1" onclick="editCita(${
              c.cita_id
            })">Editar</button>
            <button class="btn btn-sm btn-danger" onclick="deleteCita(${
              c.cita_id
            })">Eliminar</button>
          </td>
        </tr>
      `);
    });
  }

  /* ---------------- EDIT ---------------- */
  window.editCita = function (id) {
    $("#status-citas").text("Cargando cita...");

    $.ajax({
      url: ENDPOINT_CITAS + "/" + id,
      method: "GET",
      dataType: "json",
    })
      .done((c) => {
        $("#cita_id").val(c.cita_id);
        $("#cliente_id").val(c.cliente_id);
        $("#servicio_id").val(c.servicio_id);
        $("#estado_id").val(c.estado_id);

        // Convertir fecha Oracle -> datetime-local
        let dt = c.fecha_hora.replace(" ", "T").substring(0, 16);
        $("#fecha_hora").val(dt);

        $("#notas").val(c.notas);

        citaModal.show();
      })
      .fail(() => $("#status-citas").text("Error cargando cita"));
  };

  /* ---------------- UPDATE ---------------- */
  function updateCita() {
    const id = $("#cita_id").val();

    const data = {
      cliente_id: Number($("#cliente_id").val()),
      servicio_id: Number($("#servicio_id").val()),
      estado_id: Number($("#estado_id").val()),
      fecha_hora: $("#fecha_hora").val().replace("T", " ") + ":00",
      notas: $("#notas").val(),
    };

    $.ajax({
      url: ENDPOINT_CITAS + "/" + id,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify(data),
    })
      .done(() => {
        citaModal.hide();
        loadCitas();
      })
      .fail((xhr) => {
        $("#cita-form-error")
          .removeClass("d-none")
          .text("Error actualizando cita: " + xhr.responseText);
      });
  }

  /* ---------------- DELETE ---------------- */
  window.deleteCita = function (id) {
    if (!confirm(`¿Eliminar cita ${id}?`)) return;

    $.ajax({
      url: ENDPOINT_CITAS + "/" + id,
      method: "DELETE",
    })
      .done(loadCitas)
      .fail(() => alert("Error eliminando cita"));
  };
});
