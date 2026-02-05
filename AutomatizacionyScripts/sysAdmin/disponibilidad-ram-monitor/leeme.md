 # 📊 Monitoreo de Infraestructura y Base de Datos

Construí un sistema de monitoreo combinando Bash / PowerShell, MSSQL, Python y Windows / Linux Server.

El objetivo de este proyecto es anticipar incidentes, detectar comportamientos anómalos y proveer información clara y accionable para equipos de Operaciones, Infraestructura, Bases de Datos y Gestión TI. El monitoreo se divide en tres ejes:

* 📦 **Base de Datos (SQL Server)**: conexiones activas, sesiones, usuarios y tamaño de archivos.
* 🌐 **Disponibilidad de servidor y aplicación web**: disponibilidad de servidor y puerto de aplicación.
* 🧠 **Consumo de memoria RAM y procesos críticos del sistema operativo**: muestra procesos de mayor consumo y exceso de consumo con base en umbrales definidos.

Este monitoreo nos permite:
* ✔️ Detectar caídas de servidores físicos o virtuales.
* ✔️ Validar si una aplicación web está realmente disponible, no solo si el servidor responde.
* ✔️ Identificar excesos de consumo de memoria RAM antes de que el sistema colapse.
* ✔️ Analizar conexiones activas a la base de datos y saber quién se conecta, con qué aplicación.
* ✔️ Apoyar en análisis post-incidente (postmortem) con evidencia histórica.

Es un enfoque proactivo, útil para:

* 👩‍💻 Equipos de Operaciones / NOC
* 🧑‍💼 Administradores de Base de Datos (DBA)
* 🏗️ Infraestructura y Sistemas
* 🔐 Seguridad y Auditoría TI
* 📈 Gestión y liderazgo tecnológico

---

## 🏗️ Componentes del sistema

### Monitoreo de Disponibilidad de Servidores y Aplicaciones 📈
**Archivo de salida:** `[Logs_disponibilidad.txt]`. Este script valida:
1. 🖥️ Estado del servidor físico ->  (online / offline).
2. 🌐 Disponibilidad real de la aplicación -> validando si el puerto TCP está disponible.

Estados detectados:
* ✅ Servidor online
* ❌ Servidor offline
* ❌ Puerto inaccesible (probablemente por Firewall, IIS detenido, pool caído, servicio inactivo)
* ✅ Aplicación escuchando correctamente

**Diferencial importante:** --> No asumir que un servidor encendido implica una aplicación disponible https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/AutomatizacionyScripts/sysAdmin/disponibilidad-ram-monitor/disponibilidad_monitor_resultado.png

### Monitoreo de consumo de Memoria RAM y procesos 📈
**Archivo de salida:** `ram_monitor.log`. Este módulo monitorea en tiempo real:
* 📊 Porcentaje de uso de memoria RAM
* 📉 Memoria libre disponible
* ⚠️ Umbrales de alerta: CRÍTICO - EMPEORANDO - RECUPERADO

Cuando el consumo sobrepasa el umbral, registra automáticamente:
* Top de procesos consumidores de memoria 
* Consumo exacto en MB

**Beneficio clave:** Permite actuar antes de un colapso del sistema operativo https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/AutomatizacionyScripts/sysAdmin/disponibilidad-ram-monitor/ram_memoria_monitor_resultado.png

### Monitoreo de Base de Datos (Python + SQL) 📈
**Archivo de salida:** `resultados_160712.json` . Este módulo ejecuta consultas SQL que permiten:
* Contar conexiones activas al momento.
* Listar sesiones vivas, indicando: Usuario - Host - Programa que origina la conexión (Python, SSMS, servicios, etc.)
* Revisar tamaño de archivo de datos y logs de la base de datos, generando resultados en log.json.

🔎 Ejemplo de información obtenida:
* Detección de scripts Python conectados a la BD
* Identificación de usuarios humanos vs servicios
* Tamaño de archivo .mdf y .ldf para **Control de crecimiento de archivos**

**Beneficio clave:** Visibilidad de la actividad real de la base de datos https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/AutomatizacionyScripts/sysAdmin/monitoreo-SQLserver-viaPython/monitor_BD_resultado.png

---
##  ⚠️  Requisitos para que funcione

### Software
* S.O Windows Server / Linux Ubunu Server
* PowerShell 5.1 o superior / Bash
* Python 3.8+, validar cadena de conexión a SQL server (IP, puerto, base de datos, usuario)
* SQL Server, validar conectividad a bd vía puerto TCP 
* Usuario con permisos de acceso y lectura de información de la base de datos.

#### monitoreo Disponibilidad -> Windows o Linux Server
* Ajustar IP/hostname, puerto, ruta de logs en el script .ps1 o .sh
* Programar ejecución periódica (Task Scheduler o cron)

#### monitoreo Memoria -> Windows Server
* Definir umbrales de alerta, de intervalo de ejecución, intervalo de realertamiento, ruta de logs en script script .ps1 o .sh
* Recomendación: Ejecutar en intervalos cortos
* Programar ejecución periódica (Task Scheduler o cron)
* Analizar logs ante incidentes

#### monitoreo Base de datos -> motor MSSQL
* Configurar conexión SQL en el script Python,  validar consultas SQL en script SQL de consulta a la base
* Ejecutar el script python
* Revisar salida JSON en ruta especificada
---

## 🧠 Implementación
Recomendaciones:
* Ejecutar vía Task Scheduler o Cron
* Centralizar logs en un repositorio
* Integrar con SIEM, Plataformas de Observabilidad, Dashboards de operación

Este proyecto puede ser la base de un sistema de observabilidad más robusto, los beneficios que brinda son:
✔ Prevención de caídas
✔ Reducción de tiempo de indisponibilidad
✔ Evidencia objetiva para auditorías
✔ Soporte a decisiones de capacidad
✔ Bajo costo (scripts livianos)
✔ Fácil integración con sistemas de monitoreo mayores

#### 📌 Valor agregado
Este no es solo monitoreo técnico, es visibilidad operativa real con foco en continuidad del negocio, ideal para entornos donde cada minuto de caída tiene impacto económico y reputacional.

#### 📌 Autoría y uso
> Proyecto desarrollado con enfoque profesional y empresarial. Puede adaptarse, escalarse o integrarse según las necesidades de la organización.

✨ con esta base estamos listos para producción, auditoría y operación 24/7* ✨

