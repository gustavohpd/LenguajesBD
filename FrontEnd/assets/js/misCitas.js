$(document).ready(function () {
  const usuario = JSON.parse(localStorage.getItem("usuario"));

  if (!usuario || usuario.rol_id != 7) {
    alert("Debe iniciar sesión para ver sus citas.");
    window.location.href = "login.html";
    return;
  }

  const cliente_id = usuario.cliente_id;

  function cargarCitas() {
    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/citas",
      method: "GET",
      success: function (data) {
        const citasCliente = data.filter((c) => c.cliente_id == cliente_id);

        let html = "";

        citasCliente.forEach((c) => {
          html += `
            <tr>
              <td>${c.cita_id}</td>
              <td>${c.servicio_nombre}</td>
              <td>${c.fecha_hora}</td>
              <td>${c.notas ?? ""}</td>
              <td>${c.nombre_estado}</td>
              <td>
                ${
                  c.estado_id == 1
                    ? `<button class="btn btn-danger btn-sm cancelar" data-id="${c.cita_id}">
                        Cancelar
                      </button>`
                    : "—"
                }
              </td>
            </tr>
          `;
        });

        $("#tabla-citas").html(html);
      },
      error: function () {
        alert("Error cargando citas.");
      },
    });
  }

  cargarCitas();

  // =============================
  // CANCELAR CITA
  // =============================
  $(document).on("click", ".cancelar", function () {
    const cita_id = $(this).data("id");

    if (!confirm("¿Desea cancelar esta cita?")) return;

    $.ajax({
      url: `http://localhost/LenguajesBD/API/public/index.php/api/citas/${cita_id}`,
      method: "DELETE",
      success: function () {
        alert("Cita cancelada");
        cargarCitas(); // refrescar tabla
      },
      error: function (xhr) {
        console.error(xhr.responseText);
        alert("No se pudo cancelar la cita.");
      },
    });
  });
});
