var url_base = "http://localhost/LenguajesBD/API/public/index.php";
async function fetchData(endpoint) {
  const uri = url_base + endpoint;
  try {
    const response = await fetch(uri);

    if (!response.ok) {
      throw new Error(`http error, status ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error fetching data", error);
  }
}

// document.getElementById("prueba").addEventListener("click", function(){
//     fetchData("/api/clientes")
// })

$("#prueba").on("click", function () {
  fetchData("/api/clientes").then((data) => {
    console.log(data);
  });
});
