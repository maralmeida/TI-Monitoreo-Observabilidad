const enviarBtn = document.getElementById('boton'); // Obtiene el botón por su nuevo ID único

// Asigna el evento 'click' al botón
enviarBtn.addEventListener('click', generarIngreso);

// Función que se ejecuta al hacer clic en el botón
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
