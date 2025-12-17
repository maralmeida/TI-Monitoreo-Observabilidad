const enviarBtn = document.getElementById('boton'); // Obtiene el botón por su nuevo ID único

// Asigna el evento 'click' al botón
enviarBtn.addEventListener('click', generarIngreso);

async function generarIngreso() {
    // Obtenemos los valores igual que antes
    const datos = {
        nombre: document.getElementById('nombre').value,
        edad: document.getElementById('edad').value,
        genero: document.querySelector('input[name="genero"]:checked')?.value,
        pais: document.querySelector('input[name="pais"]:checked')?.value,
        profesion: document.querySelector('input[name="profesion"]:checked')?.value
    };

    // --- NUEVO: Envío al servidor ---
    try {
        const response = await fetch('./ingresoBD.php', {
            method: 'POST', // Queremos "enviar" (publicar) datos
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(datos) // Convertimos el objeto en texto plano
        });

        const resultado = await response.json();

        if (resultado.status === "success") {
            alert("¡Éxito! Guardado en la base de datos.");
            
            // Tu lógica original para mostrar en el div
            document.getElementById('muestranombre').textContent = datos.nombre;
            document.getElementById("flowcontrol").style.display = 'block';
        } else {
            alert("Error al guardar: " + resultado.message);
        }
    } catch (error) {
        console.error("No se pudo conectar con el PHP:", error);
    }
}












/*Función que se ejecuta al hacer clic en el botón
function generarIngreso() {
    // Se obtienen los valores de los campos al momento del clic
    const jsnombre = document.getElementById('nombre').value;
    const jsedad = document.getElementById("edad").value;
    // Se busca el radio button seleccionado por su 'name'
    const jsgeneroSeleccionado = document.querySelector('input[name="genero"]:checked').value;
    const jspaisSeleccionado = document.querySelector('input[name="pais"]:checked').value;
    const jsprofesionSeleccionada = document.querySelector('input[name="profesion"]:checked').value;

    // Mostrar los valores en el div 'flowcontrol'
    document.getElementById('muestranombre').textContent = jsnombre;
    document.getElementById('muestraedad').textContent = jsedad;
    



    document.getElementById('muestragenero').textContent = jsgeneroSeleccionado;
    document.getElementById('muestrapais').textContent = jspaisSeleccionado;
    document.getElementById('muestraprofesion').textContent = jsprofesionSeleccionada;

    // Muestra el div oculto
    document.getElementById("flowcontrol").style.display = 'block';

    //console.log("Datos ingresados:", { nombre, edad, genero, pais, profesion });
}
*/