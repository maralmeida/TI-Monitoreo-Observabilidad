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
            
            // muestro en el div para usuario de navegador
            document.getElementById('muestranombre').textContent = datos.nombre;
            document.getElementById('muestraedad').textContent = datos.edad;
            document.getElementById('muestragenero').textContent = datos.genero;
            document.getElementById('muestrapais').textContent = datos.pais;
            document.getElementById('muestraprofesion').textContent = datos.profesion;
            document.getElementById("flowcontrol").style.display = 'block';
        } else {
            alert("Error al guardar: " + resultado.message);
        }
    } catch (error) {
        console.error("No se pudo conectar con el PHP:", error);
    }
}









