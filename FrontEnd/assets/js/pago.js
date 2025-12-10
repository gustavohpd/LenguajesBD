$(document).ready(function () {
  const usuario = JSON.parse(localStorage.getItem("usuario"));
  const carrito = JSON.parse(localStorage.getItem("carrito")) || [];

  if (!usuario) {
    alert("Debe iniciar sesión para pagar.");
    window.location.href = "login.html";
    return;
  }

  if (carrito.length === 0) {
    alert("El carrito está vacío.");
    window.location.href = "carrito.html";
    return;
  }

  $("#form-pago").submit(function (e) {
    e.preventDefault();

    const payload = {
      cliente_id: usuario.cliente_id,
      metodo_pago_id: 1, // TARJETA
      carrito: carrito.map((item) => ({
        producto_id: item.id,
        precio: item.precio,
        cantidad: item.cantidad,
      })),
    };

    $.ajax({
      url: "http://localhost/LenguajesBD/API/public/index.php/api/pago",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),

      success: function (res) {
        localStorage.removeItem("carrito");
        window.location.href = `pago_exitoso.html?factura=${res.factura_id}`;
      },

      error: function (xhr) {
        console.error(xhr.responseText);
        alert("Error al procesar pago.");
      },
    });
  });
});
