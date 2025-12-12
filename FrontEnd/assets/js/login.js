$(document).ready(function () {
  $("#btn-login").click(function (e) {
    e.preventDefault();

    const correo = $("#login-correo").val().trim();
    const password = $("#login-pass").val().trim();

    if (!correo || !password) {
      alert("Debe ingresar correo y contraseña.");
      return;
    }

    const payload = {
      correo: correo,
      password: password,
    };

    console.clear();
    console.log("CLICK LOGIN ENVIADO SOLO UNA VEZ");

    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/login",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),

      success: function (resp) {
        console.log("LOGIN RESPONSE =>", resp);

        if (!resp.success) {
          alert("Credenciales incorrectas.");
          return;
        }

        // Guardar datos del usuario
        localStorage.setItem("usuario", JSON.stringify(resp));

        // Redirección según rol
        if (resp.rol_id == 1) {
          // ADMIN -> Dashboard
          window.location.href = "dashboardAdmin.html";
        } else {
          // CLIENTE -> Página principal
          window.location.href = "index.html";
        }
      },

      error: function (xhr) {
        console.error("LOGIN ERROR =>", xhr.responseText);
        console.error("STATUS =>", xhr.status);
        alert("Error al iniciar sesión.");
      },
    });
  });
});
