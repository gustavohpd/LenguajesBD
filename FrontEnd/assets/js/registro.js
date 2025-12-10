$(document).ready(function () {
  $("#form-registro").submit(function (e) {
    e.preventDefault();

    const data = {
      nombre: $("#reg-nombre").val(),
      apellido_paterno: $("#reg-apellido1").val(),
      apellido_materno: $("#reg-apellido2").val(),
      correo: $("#reg-correo").val(),
      telefono: $("#reg-telefono").val(),
      password: $("#reg-password").val(),
    };

    // 1) Registrar usuario
    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/registro",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),

      success: function (res) {
        if (res.status !== "success") {
          $("#registro-error").removeClass("d-none").text(res.message);
          return;
        }

        // 2) Hacer login automático
        const loginPayload = {
          correo: data.correo,
          password: data.password,
        };

        $.ajax({
          url: "http://localhost/LenguajesBD/API/public/index.php/api/login",
          method: "POST",
          contentType: "application/json",
          data: JSON.stringify(loginPayload),

          success: function (loginRes) {
            if (!loginRes.success) {
              alert("Cuenta creada, pero no se pudo iniciar sesión.");
              return;
            }

            // 3) Guardar sesión COMPLETA (incluye rol_id)
            localStorage.setItem(
              "usuario",
              JSON.stringify({
                usuario_id: loginRes.usuario_id,
                cliente_id: loginRes.cliente_id,
                nombre: loginRes.nombre,
                rol_id: loginRes.rol_id,
                correo: loginRes.correo,
              })
            );

            alert("Cuenta creada e iniciada sesión correctamente.");
            window.location.href = "index.html";
          },

          error: function () {
            alert("Cuenta creada, pero ocurrió un error al iniciar sesión.");
          },
        });
      },

      error: function () {
        alert("Error al registrar usuario.");
      },
    });
  });
});
