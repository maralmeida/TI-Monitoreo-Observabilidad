 # 📊 Monitoreo Integral de Infraestructura y Base de Datos

Construí un sistema de monitoreo técnico empresarial orientado a la disponibilidad, uso de recursos y actividad en base de datos, combinando PowerShell, MSSQL y Windows Server.

El objetivo de este proyecto es anticipar incidentes, detectar comportamientos anómalos y proveer información clara y accionable para equipos de Operaciones, Infraestructura, Bases de Datos y Gestión TI.

El monitoreo se divide en tres grandes ejes:

* 📦 **Base de Datos (SQL Server)**: conexiones activas, sesiones, usuarios y tamaño de archivos.
* 🌐 **Disponibilidad de servidor y aplicación web**: disponibilidad de servidor y puerto de aplicación.
* 🧠 **Consumo de memoria RAM y procesos críticos del sistema operativo**: muestra procesos de mayor consumo y exceso de consumo con base en umbrales definidos.

Este monitoreo nos permite:
* ✔️ Detectar caídas de servidores físicos o virtuales.
* ✔️ Validar si una aplicación web está realmente disponible, no solo si el servidor responde.
* ✔️ Identificar excesos de consumo de memoria RAM antes de que el sistema colapse.
* ✔️ Analizar conexiones activas a la base de datos y saber quién se conecta, desde dónde y con qué aplicación.
* ✔️ Apoyar en análisis post-incidente (postmortem) con evidencia histórica.

Es un enfoque proactivo, no reactivo.

---

## ¿A quién le sirve?
A empresarias, orientado a:

* 👩‍💻 Equipos de Operaciones / NOC
* 🧑‍💼 Administradores de Base de Datos (DBA)
* 🏗️ Infraestructura y Sistemas
* 🔐 Seguridad y Auditoría TI
* 📈 Gestión y liderazgo tecnológico

Especialmente útil en entornos Bancarios, Financieros, Medios de pago, Aplicaciones críticas 24/7

---

## 🏗️ Componentes del sistema

### Monitoreo de Base de Datos (Python + SQL) 📈
**Archivo de salida:** `resultados_160712.json` . Este módulo ejecuta consultas SQL que permiten:
* Contar conexiones activas al momento.
* Listar sesiones vivas, indicando: Usuario - Host - Programa que origina la conexión (Python, SSMS, servicios, etc.)
* Revisar tamaño de archivo de datos y logs de la base de datos, generando resultados en log.json.

🔎 Ejemplo de información obtenida:
* Detección de scripts Python conectados a la BD
* Identificación de usuarios humanos vs servicios
* Tamaño de archivo .mdf y .ldf para **Control de crecimiento de archivos**

**Beneficio clave:** Visibilidad total de la actividad real de la base de datos.

### Monitoreo de disponibilidad de servidor y aplicación (PowerShell) 📈
**Archivo de salida:** `Logs_disponibilidad.txt`. Este script valida:
1. 🖥️ Estado del servidor físico ->  (online / offline).
2. 🌐 Disponibilidad real de la aplicación -> validando si el puerto TCP está escuchando.

Estados detectados:
* ✅ Servidor online
* ❌ Servidor offline
* ❌ Puerto inaccesible (probablemente por Firewall, IIS detenido, pool caído)
* ✅ Aplicación escuchando correctamente

**Diferencial importante:** --> No asumir que un servidor encendido implica una aplicación disponible.

### Monitoreo de memoria RAM y procesos (PowerShell / Python) 📈
**Archivo de salida:** `log_memoria.txt`. Este módulo monitorea en tiempo real:
* 📊 Porcentaje de uso de memoria RAM
* 📉 Memoria libre disponible
* ⚠️ Umbrales de alerta: CRÍTICO - EMPEORANDO - RECUPERADO

Cuando el consumo es elevado, registra automáticamente:
* Top de procesos consumidores de memoria 
* Consumo exacto en MB

Ejemplos reales detectados:
* Navegadores (Edge, Opera)
* Máquinas virtuales
* Compresión de memoria
* Antivirus

**Beneficio clave:** Permite actuar antes de un colapso del sistema operativo.

---
##  ⚠️  Requisitos para que funcione

### Software
* S.O Windows Server / Windows
* PowerShell 5.1 o superior
* Python 3.8+, validar cadena de conexión a SQL server (IP, puerto, base de datos, usuario)
* SQL Server, validar conectividad vía puerto TCP 
* Usuario con permisos de lectura a vistas del sistema (`sys.dm_exec_sessions`, etc.)

#### monitoreo Base de datos -> motor MSSQL
* Configurar conexión SQL en el script Python,  validar consultas SQL en script SQL de consulta a la base
* Ejecutar el script python
* Revisar salida JSON en ruta especificada

#### monitoreo Disponibilidad -> Windows Server
* Ajustar IP/hostname, puerto, ruta de logs en el script PowerShell
* Programar ejecución periódica (Task Scheduler)

#### monitoreo Memoria -> Windows Server
* Definir umbrales de alerta, de intervalo de ejecución, intervalo de realertamiento, ruta de logs en script powershell
* Recomendación: Ejecutar en intervalos cortos
* Analizar logs ante incidentes

---

## 🧠 Implementación en entornos empresariales
Recomendaciones:
* Ejecutar vía Task Scheduler
* Centralizar logs en un repositorio
* Integrar con SIEM, Plataformas de observabilidad, Dashboards corporativos

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

