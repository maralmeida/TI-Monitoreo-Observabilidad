## 🗄️ Automatización de Respaldo y Restauranción de bases de datos con SQL Server 

Construí una solución basada en Python para automatizar el backup y la restauración de bases de datos SQL Server, permitiendo realizar respaldos y restauraciones, eliminando la configuración manual de usuarios y permisos. Es útil en Administración de Sistemas y DevOps al aplicar:

* Automatización de Tareas Críticas: Reduce el factor de error humano en la recuperación de desastres.
* Separación de Funciones: Los scripts separan la lógica de respaldo de la de restauración, permitiendo una gestión modular.
* Trazabilidad: El sistema de logs permite monitorear el estado de la base de datos de forma remota.

### 📂 Scripts y componentes necesarios:
1- respaldo.py: Script automatizado que genera el archivo .bak, lo valida y lo mueve a una ubicación segura (File Server sugerido), resultado: https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/AutomatizacionyScripts/sysAdmin/respaldobd/respaldo_resultado.png

2- restaura.py: Script de restauración de la base que gestiona la desconexión de usuarios, la restauración física y la sincronización de permisos de la aplicación (solución de usuarios huérfanos), resultado: https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/AutomatizacionyScripts/sysAdmin/respaldobd/restauracion_resultado.png

3- SitioPruebas.bak: Artefacto de base de datos listo para ser desplegado (base portable). Resultado de restauración: https://github.com/maralmeida/TI-Monitoreo-Observabilidad/blob/main/AutomatizacionyScripts/sysAdmin/respaldobd/bd_funcional_resultado.png

4- ruta/logs: Directorio que almacena logs que registran el éxito o error de cada operación con marcas de tiempo.

5- tareas programas: sugerido, task scheduler o Cronjobs para eliminar intervención manual de ejecución en el tiempo

### 🚀 Funcionalidades Clave
* Gestión de Conexiones: El script de restauración pone la base de datos en modo SINGLE_USER automáticamente para evitar errores de "archivo en uso".
* Sincronización de Usuarios: Resuelve el problema común de pérdida de acceso tras restaurar, vinculando los Logins del servidor con los Usuarios de la base de datos.
* Arquitectura de Logs: Genera reportes detallados en archivos físicos para auditoría y resolución de problemas.
* Flujo Desatendido: Diseñado para ejecutarse mediante tareas programadas o activadores de red sin intervención humana.

🛠️ Requisitos
* Python 3.13.7 o superior.
* SQL Server Command Line Utilities (sqlcmd) configurado en el PATH.
* Permisos de Administración de la Base de Datos (sysadmin / backup operator) para el usuario de ejecución de script.
* ajustar rutas de lectura y almacenamiento de componentes.
* ajustar datos de usuarios.
