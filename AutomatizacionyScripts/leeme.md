 # 📊 Monitoreo Integral de Infraestructura y Base de Datos

Implementación de un sistema de monitoreo técnico empresarial orientado a la disponibilidad, uso de recursos y actividad en base de datos, combinando PowerShell, MSSQL y Windows Server.

El objetivo de este proyecto es anticipar incidentes, detectar comportamientos anómalos y proveer información clara y accionable para equipos de Operaciones, Infraestructura, Bases de Datos y Gestión TI.

El monitoreo se divide en tres grandes ejes:

* 📦 **Base de Datos (SQL Server)**: conexiones activas, sesiones, usuarios y tamaño de archivos.
* 🌐 **Disponibilidad de servidor y aplicación web (IIS / Puerto TCP)**.
* 🧠 **Consumo de memoria RAM y procesos críticos del sistema operativo**.

---

## ¿Para qué sirve este proyecto? 🌐
* Detectar caídas de servidores físicos o virtuales.
* Validar si una aplicación web está realmente disponible, no solo si el servidor responde.
* Identificar excesos de consumo de memoria RAM antes de que el sistema colapse.
* Analizar conexiones activas a la base de datos y saber quién se conecta, desde dónde y con qué aplicación.
* Apoyar en análisis post-incidente (postmortem) con evidencia histórica.

Es un enfoque proactivo, no reactivo.

---

## ¿A quién le sirve?

A empresarias, orientado a:

* 👩‍💻 Equipos de Operaciones / NOC
* 🧑‍💼 Administradores de Base de Datos (DBA)
* 🏗️ Infraestructura y Sistemas
* 🔐 Seguridad y Auditoría TI
* 📈 Gestión y liderazgo tecnológico

Especialmente útil en entornos:

* Bancarios, Financieros, Medios de pago, Aplicaciones críticas 24/7

---

## 🏗️ Componentes del sistema

### Monitoreo de Base de Datos (Python + SQL) 📈

**Archivo de salida:** `resultados_160712.json`

Este módulo ejecuta consultas SQL que permiten:

* Contar conexiones activas.
* Listar sesiones vivas, indicando:

  * Usuario
  * Host
  * Programa que origina la conexión (Python, SSMS, servicios, etc.)
* Revisar tamaño y configuración de archivos de base de datos y logs.

🔎 Ejemplo de información obtenida:

* Detección de scripts Python conectados a la BD
* Identificación de usuarios humanos vs servicios
* Control de crecimiento de archivos

**Beneficio clave:** Visibilidad total de la actividad real de la base de datos.

### Monitoreo de disponibilidad de servidor y aplicación (PowerShell) 📈

**Archivo de salida:** `Logs_disponibilidad.txt`

Este script valida:

1. 🖥️ **Estado del servidor físico** (online / offline).
2. 🌐 **Disponibilidad real de la aplicación**, validando si el **puerto TCP** está escuchando.

Estados detectados:

* ✅ Servidor online
* ❌ Servidor offline
* ❌ Puerto inaccesible (Firewall, IIS detenido, pool caído)
* ✅ Aplicación escuchando correctamente

**Diferencial importante:**

> No asume que un servidor encendido implica una aplicación disponible.

### Monitoreo de memoria RAM y procesos (PowerShell / Python) 📈

**Archivo de salida:** `log_memoria.txt`

Este módulo monitorea en tiempo real:

* 📊 Porcentaje de uso de memoria RAM
* 📉 Memoria libre disponible
* ⚠️ Umbrales de alerta:

  * CRÍTICO
  * EMPEORANDO
  * RECUPERADO

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

##  Beneficios empresariales

✔ Prevención de caídas
✔ Reducción de tiempo de indisponibilidad
✔ Evidencia objetiva para auditorías
✔ Soporte a decisiones de capacidad
✔ Bajo costo (scripts livianos)
✔ Fácil integración con sistemas de monitoreo mayores

---

##  ⚠️  Requisitos para que funcione

### Software

* Windows Server / Windows
* PowerShell 5.1 o superior
* Python 3.8+
* SQL Server
* Acceso de lectura a vistas del sistema (`sys.dm_exec_sessions`, etc.)

### Permisos

* Permisos de ejecución de scripts
* Acceso a puertos TCP a validar
* Usuario SQL con permisos de monitoreo

---

## 🧠 ¿Cómo usarlo?

### Paso 1: Base de datos

* Configurar conexión SQL en el script Python
* Ejecutar el script
* Revisar salida JSON

### Paso 2: Disponibilidad

* Ajustar IP/hostname y puerto en el script PowerShell
* Programar ejecución periódica (Task Scheduler)

### Paso 3: Memoria

* Definir umbrales de alerta
* Ejecutar en intervalos cortos
* Analizar logs ante incidentes

---

## 🧠 Implementación en entornos empresariales
Recomendaciones:
* Ejecutar vía Task Scheduler
* Centralizar logs en un repositorio
* Integrar con SIEM, Plataformas de observabilidad, Dashboards corporativos

Este proyecto puede ser la base de un sistema de observabilidad más robusto.

---

#### 📌 Valor agregado
Este no es solo monitoreo técnico, es visibilidad operativa real con foco en continuidad del negocio, ideal para entornos donde cada minuto de caída tiene impacto económico y reputacional.

#### 📌 Autoría y uso
> Proyecto desarrollado con enfoque profesional y empresarial. Puede adaptarse, escalarse o integrarse según las necesidades de la organización.

✨ con esta base estamos listos para producción, auditoría y operación 24/7* ✨

