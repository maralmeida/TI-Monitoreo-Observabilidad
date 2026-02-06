import subprocess
import sys

# --- CONFIGURACIÓN ---
#nombre del contenedor en docker compose
CONTAINER_NAME = "mssql-server-sitiosapp"
DB_NAME = "SitioPruebas"
# Ruta interna del contenedor (mapeada en tu docker-compose)
BACKUP_FILE = "/var/opt/mssql/backup/SitioPruebas_2026-01-28_1640.bak"

# Usamos SA para la conexión porque tiene permisos para crear logins y restaurar
ADMIN_USER = "sa"
ADMIN_PASS = "Sql_Admin_2026!"

# el usuario con db.backupoperator role para la aplicación
APP_USER = "respaldabd"
APP_PASS = "respaldabd"

# --- NUEVOS USUARIOS DE LAS APPS ---
# Usuario 1
PHP_USER_1 = "sitioapp_php"
PHP_PASS_1 = "sitioapp_php" 

# Usuario 2
PHP_USER_2 = "usuario_php"
PHP_PASS_2 = "usuario_php"

def restaurar_base_de_datos():
    print(f"--- Iniciando Proceso en Contenedor: {CONTAINER_NAME} ---")

    # --- CAMBIO IMPORTANTE: DIVIDIMOS LA CONSULTA EN BLOQUES ---
    # Esto evita el error "Database does not exist" al inicio del script.

    # 1. Crear logins en el servidor (Nivel Master - Siempre funciona)
    sql_logins = (
        f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{APP_USER}') "
        f"CREATE LOGIN [{APP_USER}] WITH PASSWORD = '{APP_PASS}',CHECK_POLICY = OFF; "
        f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{PHP_USER_1}') "
        f"CREATE LOGIN [{PHP_USER_1}] WITH PASSWORD = '{PHP_PASS_1}',CHECK_POLICY = OFF; "
        f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{PHP_USER_2}') "
        f"CREATE LOGIN [{PHP_USER_2}] WITH PASSWORD = '{PHP_PASS_2}', CHECK_POLICY = OFF; "
    )

    # 2. Echar a todos de la DB actual modod SINGLE_USER (SOLO SI EXISTE) y Restaurar
    sql_restore = (
        f"IF EXISTS (SELECT * FROM sys.databases WHERE name = '{DB_NAME}') "
        f"BEGIN ALTER DATABASE [{DB_NAME}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE END; "
        f"RESTORE DATABASE [{DB_NAME}] FROM DISK='{BACKUP_FILE}' WITH REPLACE, "
        f"MOVE 'SitioPruebas' TO '/var/opt/mssql/data/SitioPruebas.mdf', "
        f"MOVE 'SitioPruebas_log' TO '/var/opt/mssql/data/SitioPruebas_log.ldf'; "
    )

    # 3. Volver a MULTI_USER y Vincular TODOS los usuarios (Auto_Fix)
    # Estos comandos se corren DESPUÉS de que la DB ya fue creada por el RESTORE.
    sql_post = (
        f"ALTER DATABASE [{DB_NAME}] SET MULTI_USER; "
        f"USE [{DB_NAME}]; "
        f"EXEC sp_change_users_login 'Auto_Fix', '{APP_USER}'; "
        f"EXEC sp_change_users_login 'Auto_Fix', '{PHP_USER_1}'; "
        f"EXEC sp_change_users_login 'Auto_Fix', '{PHP_USER_2}'; "
    )

    # Lista de bloques para ejecutar en orden
    bloques_sql = [sql_logins, sql_restore, sql_post]

    try:
        for i, fragmento_sql in enumerate(bloques_sql):
            # Agregamos comillas dobles a la contraseña para manejar caracteres especiales como '!'
            comando = (
                f'docker exec -i {CONTAINER_NAME} '
                f'/opt/mssql-tools18/bin/sqlcmd -b -S localhost -U {ADMIN_USER} -P "{ADMIN_PASS}" -C -Q "{fragmento_sql}"'
            )
            
            if i == 1: print(f"Restaurando base de datos '{DB_NAME}'...")
            resultado = subprocess.run(comando, shell=True, check=True, capture_output=True, text=True)
            if resultado.stdout: print(resultado.stdout)

        print(f" ¡Éxito! DB restaurada y usuarios '{APP_USER}', '{PHP_USER_1}', '{PHP_USER_2}' vinculados.")
        
    except subprocess.CalledProcessError as e:
        print(f" Error en la ejecución.")
        print(f"STDOUT: {e.stdout}") # Salida normal de SQL
        print(f"STDERR: {e.stderr}") # El error específico de SQL Server o Docker
        sys.exit(1)

if __name__ == "__main__":
    restaurar_base_de_datos()
