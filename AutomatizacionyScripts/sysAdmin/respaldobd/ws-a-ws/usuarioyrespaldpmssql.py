import subprocess
import datetime
import os

# --- CONFIGURACIÓN GLOBAL ---
DB_NAME = "SitioPruebas"
BACKUP_FILE = r"C:\scriptspublicos\backups\SitioPruebas_2026-01-28_1640.bak"
DB_USER = "respaldabd"
DB_PASS = "respaldabd"
APP_USER = "sitioapp_php"
APP_PASS = "sitioapp_php"
LOG_FILE = r"C:\scriptspublicos\logsbackup\restauramssql.log"

def escribir_log(mensaje):
    """Escribe en log y consola con timestamp."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    linea = f"[{timestamp}] {mensaje}"
    # Crear carpeta de logs si no existe
    os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
    with open(LOG_FILE, "a") as f:
        f.write(linea + "\n")
    print(linea)

def ejecutar_sql(query, descripcion, db_context="master"):
    """
    Ejecuta SQL. Se añadió db_context para asegurar que el comando 
    se ejecute en la base de datos correcta desde el inicio.
    """
    # -d especifica la base de datos inicial para evitar errores de USE internos
    comando = [
        "sqlcmd", "-b", 
        "-S", "localhost", 
        "-U", DB_USER, 
        "-P", DB_PASS, 
        "-d", db_context,
        "-Q", query
    ]
    
    try:
        # Ejecutamos sin shell=True para mayor seguridad y mejor captura de errores
        resultado = subprocess.run(comando, capture_output=True, text=True, check=True)
        escribir_log(f" ÉXITO: {descripcion}")
        return True
    except subprocess.CalledProcessError as e:
        # Aquí capturamos el error detallado de SQL
        error_detalle = e.stderr.strip() or e.stdout.strip()
        escribir_log(f" ERROR en {descripcion}: {error_detalle}")
        return False

def restaurar_todo():
    escribir_log("--- Iniciando restauración ---")

    # 1. MODO USUARIO ÚNICO (Para poder borrar/sobreescribir)
    sql_single = f"IF EXISTS (SELECT * FROM sys.databases WHERE name = '{DB_NAME}') ALTER DATABASE [{DB_NAME}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;"
    ejecutar_sql(sql_single, "Desconectar usuarios (SINGLE_USER)")

    # 2. RESTAURACIÓN
    sql_restore = f"RESTORE DATABASE [{DB_NAME}] FROM DISK = N'{BACKUP_FILE}' WITH REPLACE;"
    if not ejecutar_sql(sql_restore, f"Restaurar archivo .bak"):
        escribir_log(" DETENIDO: No se pudo restaurar el archivo físico.")
        return

    # 3. MODO MULTI USUARIO (Reactivar accesos)
    sql_multi = f"ALTER DATABASE [{DB_NAME}] SET MULTI_USER;"
    ejecutar_sql(sql_multi, "Habilitar accesos (MULTI_USER)")

    # 4. VÍNCULO DE USUARIOS (Dividido para evitar errores de contexto)
    # 4a. Crear login en el servidor si no existe
    sql_login = f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{APP_USER}') CREATE LOGIN [{APP_USER}] WITH PASSWORD = N'{APP_PASS}', CHECK_POLICY = OFF;"
    ejecutar_sql(sql_login, "Verificar Login en Servidor")

    # 4b. Vincular o crear usuario dentro de la base de datos restaurada
    sql_user = f"""
    IF EXISTS (SELECT * FROM sys.database_principals WHERE name = '{APP_USER}')
        ALTER USER [{APP_USER}] WITH LOGIN = [{APP_USER}];
    ELSE
        CREATE USER [{APP_USER}] FOR LOGIN [{APP_USER}];
    ALTER ROLE [db_datareader] ADD MEMBER [{APP_USER}];
    ALTER ROLE [db_datawriter] ADD MEMBER [{APP_USER}];
    """
    # Ejecutamos esto específicamente DENTRO de la base de datos restaurada
    ejecutar_sql(sql_user, f"Vincular permisos a {APP_USER}", db_context=DB_NAME)

    escribir_log("--- PROCESO FINALIZADO ---")

if __name__ == "__main__":
    restaurar_todo()