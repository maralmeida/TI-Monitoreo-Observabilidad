## 📝 Logging Estructurado y Trazabilidad con Node.js
Módulo de Logging Estructurado diseñado para entornos de alta disponibilidad y arquitecturas modernas. 
Mi objetivo es facilitar la observabilidad y el análisis de causa raíz (RCA) mediante la generación de registros consistentes y trazables.

🚀 Características Clave
* Logging Estructurado (JSON): Salida en formato JSON para facilitar la ingesta y análisis en herramientas como Dynatrace, ELK Stack o Splunk.

* Trazabilidad con UUID: Generación de TraceIDs únicos para cada flujo de ejecución, permitiendo la correlación de eventos entre diferentes componentes (ej. utils.js e IngresoProducto.js).

* Modo Multistream: Envío simultáneo de logs a la consola (para monitoreo en tiempo real) y a archivos locales (para persistencia y auditoría).

* Optimización de Rendimiento: Uso de la librería Pino, garantizando un impacto mínimo en el CPU del servidor.

### 🛠️ Tecnologías utilizadas
* Node.js: Entorno de ejecución.
* Pino: Librería de logging de alto rendimiento.
* UUID: Generación de identificadores únicos universales.

### 📸 Ejemplo de Ejecución
En la siguiente imagen se observa cómo el sistema mantiene el mismo ID de traza (f750bf02-b729-4403-aded-e653ddef5385) a través de diferentes componentes, permitiendo seguir el rastro de una operación específica:
    "https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/TrazabilidadyLogs/loggerPinoUUID-ejecucion.png"
### 📈 Valor para el Negocio
Este esquema de logging no es solo técnico; está diseñado para:
* Reducir el MTTR (Mean Time to Repair): Al tener logs correlacionados, el equipo de soporte N2 identifica fallos en segundos.
* Preparación para Observabilidad: Estructura compatible nativamente con herramientas APM (Dynatrace/Datadog).
* Análisis Post-Incidente: Documentación técnica precisa basada en hechos y trazas reales, no en suposiciones.
