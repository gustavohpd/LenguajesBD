function agregarAlCarrito(producto, cantidad) {
  let carrito = JSON.parse(localStorage.getItem("carrito")) || [];

  let index = carrito.findIndex((item) => item.id === producto.producto_id);

  if (index >= 0) {
    carrito[index].cantidad += cantidad;
  } else {
    carrito.push({
      id: producto.producto_id,
      nombre: producto.nombre,
      precio: Number(producto.precio),
      imagen: producto.imagen_url || "assets/img/default.png",
      cantidad: cantidad,
    });
  }

  localStorage.setItem("carrito", JSON.stringify(carrito));

  // Actualizar contador del icono
  actualizarContadorCarrito();
}

$(document).ready(function () {
  cargarCarrito();
  actualizarContadorCarrito();

  function cargarCarrito() {
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];

    if (carrito.length === 0) {
      $("#carrito-vacio").show();
      $("#carrito-contenido").hide();
      return;
    }

    $("#carrito-vacio").hide();
    $("#carrito-contenido").show();

    let html = "";
    let totalGeneral = 0;

    carrito.forEach((item, index) => {
      let subtotal = item.precio * item.cantidad;
      totalGeneral += subtotal;

      html += `
        <tr>
            <td>
                <img src="${
                  item.imagen || "assets/img/default.png"
                }" width="60" class="rounded">
                ${item.nombre}
            </td>

            <td>₡${Number(item.precio).toLocaleString("es-CR")}</td>

            <td>
                <button class="btn btn-sm btn-light btn-restar" data-index="${index}">-</button>
                <span class="mx-2">${item.cantidad}</span>
                <button class="btn btn-sm btn-light btn-sumar" data-index="${index}">+</button>
            </td>

            <td>₡${subtotal.toLocaleString("es-CR")}</td>

            <td>
                <button class="btn btn-sm btn-danger btn-eliminar" data-index="${index}">
                    Eliminar
                </button>
            </td>
        </tr>
      `;
    });

    $("#carrito-tabla").html(html);
    $("#carrito-total").text("₡" + totalGeneral.toLocaleString("es-CR"));
  }

  // Sumar cantidad
  $(document).on("click", ".btn-sumar", function () {
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
    let index = $(this).data("index");

    carrito[index].cantidad++;
    localStorage.setItem("carrito", JSON.stringify(carrito));

    cargarCarrito();
    actualizarContadorCarrito();
  });

  // Restar cantidad
  $(document).on("click", ".btn-restar", function () {
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
    let index = $(this).data("index");

    if (carrito[index].cantidad > 1) {
      carrito[index].cantidad--;
    }

    localStorage.setItem("carrito", JSON.stringify(carrito));

    cargarCarrito();
    actualizarContadorCarrito();
  });

  // Eliminar producto
  $(document).on("click", ".btn-eliminar", function () {
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
    let index = $(this).data("index");

    carrito.splice(index, 1);
    localStorage.setItem("carrito", JSON.stringify(carrito));

    cargarCarrito();
    actualizarContadorCarrito();
  });

  // Contador del carrito
  function actualizarContadorCarrito() {
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
    let cantidadTotal = carrito.reduce((sum, item) => sum + item.cantidad, 0);

    if (cantidadTotal > 0) {
      $("#cart-count").text(cantidadTotal).show();
    } else {
      $("#cart-count").hide();
    }
  }
});
