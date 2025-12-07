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

    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/login",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function (resp) {
        if (!resp.success) {
          alert("Credenciales incorrectas.");
          return;
        }

        // Guardar sesión
        localStorage.setItem("usuario", JSON.stringify(resp));

        // Redirecciones según rol
        if (resp.rol_id == 1) {
          window.location.href = "adminView.html";
        } else if (resp.rol_id == 7) {
          window.location.href = "index.html";
        } else {
          window.location.href = "index.html";
        }
      },
      error: function (xhr) {
        console.error(xhr.responseText);
        alert("Error al iniciar sesión.");
      },
    });
  });
});
