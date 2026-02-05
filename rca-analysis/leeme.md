## 📝 Dashboard Gerencial: Correlación de Eventos y Optimización de SLO
Este proyecto demuestra la transformación de datos crudos de sistemas (Logging) en información estratégica para la toma de decisiones. 
Mi enfoque fue reducir el "ruido operativo" y mejorar el cumplimiento de los Objetivos de Nivel de Servicio (SLO).

### 📈 Resumen del Impacto
A través del análisis y limpieza de datos de los logs, optimicé la visibilidad del estado de salud del aplicativo de ventas:
* Reducción de ruido: Se pasó de procesar 120 registros totales a solo 40 alertas relevantes por categoría, permitiendo al equipo de soporte enfocarse en incidentes críticos.
* Identificación de fallas: El análisis permitió detectar patrones críticos en la base de datos (DB_SQL) y en el servicio de autenticación (Auth_Service) durante horas pico.

### 🛠️ Especificaciones Técnicas
* Fuente de Datos: archivo plano con Logs estructurados de transacciones (formato .txt) que incluyen Timestamps, Severidad, Componente y TraceIDs.
* Herramientas:
  * Power BI: Modelado semántico y visualización.
  * Power Query: modo visual para formato, limpieza de información
  * DAX: Creación de medidas para cálculo de volumen de alertas y distribución de severidad.
  * Columnas calculadas: para performance en el tiempo por rangos de horas.

### 📊 Visualizaciones Clave
Monitoreo de Disponibilidad y Rendimiento. El dashboard permite visualizar de forma clara:
* 1 -> Total de Alertas por Severidad: Distribución equitativa entre alertas de severidad Alta, Media y Baja.
* 2 -> Componentes Afectados: Identificación visual de que el componente DB_SQL es el que presenta mayor cantidad de incidentes (33.33%), Identificación de los servicios críticos: DB_SQL, API_Gateway, Web_Server y Auth_Service.
* 3 -> Volumen en el Tiempo: Gráfico de líneas para identificar picos operativos en rangos de tiempo específicos.

### Resultados:
  * https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/root-cause-analysis/1.1-Gerencial-DisponibilidadAppVentas.png
  * https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/root-cause-analysis/1.2-Gerencial-DisponibilidadAppVentas-Desglose.png

### 💡 Valor para la Gestión (Business Value)
Este dashboard no solo muestra fallos, sino que habilita:
* Priorización de Mejoras: Al identificar que la base de datos es el cuello de botella principal.
* Estabilización de Servicios: Facilita el cumplimiento de los SLOs pactados con el negocio.
* Eficiencia Operativa: Reduce el tiempo de análisis manual de logs extensos.
