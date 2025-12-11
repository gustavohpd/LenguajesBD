const API = "http://localhost/LenguajesBD/API/public/index.php";

$(function () {
  $.get(API + "/api/clientes", (data) => $("#countClientes").text(data.length));

  $.get(API + "/api/servicios", (data) =>
    $("#countServicios").text(data.length)
  );

  $.get(API + "/api/productos", (data) =>
    $("#countProductos").text(data.length)
  );

  $.get(API + "/api/citas", (data) => $("#countCitas").text(data.length));

  $.get(API + "/api/proveedores", (data) =>
    $("#countProveedores").text(data.length)
  );
});
