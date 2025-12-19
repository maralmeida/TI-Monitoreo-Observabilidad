## 📝Aplicación Web para el registro de Usuarios con almacenamiento persistente

Desarrollé esta aplicación web junto con una arquitectura de red TCP/IP e infraestructura virtualizada, que permite el ingreso de información y su almacenamiento. 
* El servicio se encuentra alojado en IIS con conexión a SQL server, ambos servidores se encuentran en diferentes subredes lógicas.
* La arquitectura de red se encuentra segmentada mediante Hyper-V.
* El direccionamiento lógico es realizado mediante DHCP. Este servicio y el de DNS son dados por otro equipo servidor donde levanté estos servicios.

### ⚙️ Stack Tecnológico
* HTML, CSS, JS, PHP con FastCGI, DB drivers sqlsrv y pdo_sqlsrv
* Hyper-V, windows servers, MSSQL, IIS, usuario para BD, autenticación mixta, configuración TCP/IP y puertos, DNS, DHCP, Firewall

### 🌐 Infraestructura de Red y Gestión de Usuarios

📂 Arquitectura de Red (Layout)

El despliegue se basa en una segmentación de red Clase C para aislar los servicios:

* VLAN A (192.168.200.0/27):
Main Server (.2): Gestiona los servicios de red DNS y DHCP.
Servidor Web IIS (.3): Aloja la lógica de la aplicación.

* VLAN B (192.168.200.32/27):
SQL Server (.35): Almacena de forma persistente la información de los usuarios.
Conectividad: La comunicación entre el servidor web y la base de datos se realiza mediante ruteo entre las puertas de enlace .1 y .33.

### 🚀 Componentes del Proyecto

#### 📂 Flujo de conexión desde el cliente hasta el servidor de base de datos.

* Frontend: Formulario en HTML/JS para la captura de datos, estilos en CSS.
* Backend: script PHP mediante FastCGI en IIS. IIS envía las peticiones a php-cgi.exe, un proceso independiente always on.
* Conexión BD: Implementación de PDO con el driver sqlsrv para comunicación directa con el SQL Server en la IP 192.168.200.35.

#### 📂 Otros Módulos

Trazabilidad: Registro de eventos de conexión para debug de errores.


### 🏗️ ¿Cómo configurarlo?
  
  * Asegurar que el IIS tenga habilitado el módulo FastCGI Settings para procesar los archivos .php
  * Configurar la cadena de conexión hacia el servidor de base de datos en el archivo PHP, apuntando a instancia correcta (ip, puerto, usuario de conexión a BD).
