// en construcción api de ingreso de productos a bd y revision de inventario


const {logger, traceIDgenerator} = require('./utils');   // traigo logger y ID de traza 
const srvexpress = require('express');          //importo modulo express
const app = srvexpress();                       // instancio la app con express para usar get, post, listen ...
app.use(srvexpress.json());                     // middleware que usa express para leer JSON en solicitud req.body -> importantisimo 
const PORT = 3010;
let tasks = [];                                  // guarda en memoria volátil registros 

// rutas o endpoints APi ->  POST producto/ingreso | GET producto/inventario

app.post( '/producto/ingreso' , (req, res, next ) => {
    
    const traceID = traceIDgenerator();          // genero ID unico para trazabilidad
    const { producto, sku, cantidad, usuario } = req.body; //datos recibidos en body de post a guardar en tasks
    
    try{
        //valido
        if(!producto || !sku || !cantidad || !usuario){
            const error = new Error("Faltan campos obligatorios: producto, sku o cantidad.");
            error.statusCode = 400;
            throw error;
        }
        //guardo
        const utask = {
            uproducto : producto, usku : sku, ucantidad : cantidad, uusuario : usuario,
            creacion : new Date().toISOString()
        };
        tasks.push({ utask});  
        
        //generoresspuestas
        logger.info(`traceID: ${traceID}, componente: IngresoProducto - Ingreso EXITOSO de producto: ${producto}, sku: ${sku}, cantidad: ${cantidad}, usuario: ${usuario}, creacion: ${utask.creacion}, endpoint: ${req.originalUrl} `);
        res.status(201).json({ mensaje: 'Producto ingresado correctamente', data:req.body });  //responde a cliente
        console.log("IngresoProducto.js - Datos recibidos:", utask);


    }catch(error){
        next(error); //pasa el error al middleware de manejo de errores aqui
    }

}); 



app.listen(PORT, () => {
    console.log(`Server IngresoProducto iniciado en http://localhost:${PORT}`)
});



// mensaje de prueba para verificar que el logger y la generación de ID funcionan, para validar quitar comentario si tiene // al inicio
//logger.info(`Logger inicializado correctamente, genera ID funcionando, ejemplo ${traceID} Componente IngresoProducto.js`);