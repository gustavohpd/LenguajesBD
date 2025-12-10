// ==========================
// CONTROL DINÁMICO DEL HEADER
// ==========================

function inicializarHeader() {
  const usuario = JSON.parse(localStorage.getItem("usuario"));

  const loginBtn = document.getElementById("nav-login");
  const logoutBtn = document.getElementById("nav-logout");
  const userName = document.getElementById("nav-user-name");
  const misCitas = document.getElementById("nav-mis-citas");
  const adminBtn = document.getElementById("nav-admin");

  // Si el header aún no existe, esperamos y volvemos a intentar
  if (!loginBtn && !logoutBtn && !userName) {
    setTimeout(inicializarHeader, 100);
    return;
  }

  if (usuario) {
    if (loginBtn) loginBtn.style.display = "none";

    if (userName) {
      userName.style.display = "block";
      userName.innerText = "Hola, " + usuario.nombre;
    }

    if (logoutBtn) logoutBtn.style.display = "block";

    if (misCitas && usuario.rol_id == 7) misCitas.style.display = "block";

    if (adminBtn && usuario.rol_id == 1) adminBtn.style.display = "block";
  } else {
    if (loginBtn) loginBtn.style.display = "block";
    if (logoutBtn) logoutBtn.style.display = "none";
    if (userName) userName.style.display = "none";
    if (misCitas) misCitas.style.display = "none";
    if (adminBtn) adminBtn.style.display = "none";
  }

  // LOGOUT
  if (logoutBtn) {
    logoutBtn.onclick = () => {
      localStorage.removeItem("usuario");
      alert("Sesión cerrada");
      window.location.href = "login.html";
    };
  }
}

document.addEventListener("DOMContentLoaded", inicializarHeader);

// ==========================
// CONTADOR DEL CARRITO
// ==========================
function actualizarContadorCarrito() {
  let carrito = JSON.parse(localStorage.getItem("carrito")) || [];
  let total = carrito.reduce((sum, item) => sum + item.cantidad, 0);

  const badge = document.getElementById("cart-count");

  if (!badge) return;

  if (total > 0) {
    badge.textContent = total;
    badge.style.display = "inline-block";
  } else {
    badge.style.display = "none";
  }
}

document.addEventListener("DOMContentLoaded", actualizarContadorCarrito);
