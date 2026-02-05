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
# Usuario 1 (el que daba el error en el log)
PHP_USER_1 = "sitioapp_php"
PHP_PASS_1 = "sitioapp_php" 

# Usuario 2 (el de la otra app)
PHP_USER_2 = "usuario_php"
PHP_PASS_2 = "usuario_php"

def restaurar_base_de_datos():
    print(f"--- Iniciando Proceso en Contenedor: {CONTAINER_NAME} ---")

    # SQL MULTI-PASO:
    # 1. Crear logins en el servidor si no existen (Nivel Master)
    # 2. Echar a todos de la DB actual para poder restaurar
    # 3. Restaurar desde el archivo .bak
    # 4. Vincular TODOS los usuarios de la DB con los logins del servidor (Auto_Fix)
    sql_query = (
        # Creamos los 3 logins en el servidor por si no existen
        f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{APP_USER}') "
        f"BEGIN CREATE LOGIN [{APP_USER}] WITH PASSWORD = '{APP_PASS}', CHECK_POLICY = OFF END; "
        
        f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{PHP_USER_1}') "
        f"BEGIN CREATE LOGIN [{PHP_USER_1}] WITH PASSWORD = '{PHP_PASS_1}', CHECK_POLICY = OFF END; "
        
        f"IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '{PHP_USER_2}') "
        f"BEGIN CREATE LOGIN [{PHP_USER_2}] WITH PASSWORD = '{PHP_PASS_2}', CHECK_POLICY = OFF END; "

        # Preparar la DB y Restaurar
        f"IF EXISTS (SELECT * FROM sys.databases WHERE name = '{DB_NAME}') "
        f"BEGIN ALTER DATABASE [{DB_NAME}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE END; "
        f"RESTORE DATABASE [{DB_NAME}] FROM DISK = N'{BACKUP_FILE}' WITH REPLACE; "
        f"ALTER DATABASE [{DB_NAME}] SET MULTI_USER; "

        # Entrar a la DB restaurada y arreglar los usuarios huérfanos
        f"USE [{DB_NAME}]; "
        f"EXEC sp_change_users_login 'Auto_Fix', '{APP_USER}'; "
        f"EXEC sp_change_users_login 'Auto_Fix', '{PHP_USER_1}'; "
        f"EXEC sp_change_users_login 'Auto_Fix', '{PHP_USER_2}';"
    )


    # Comando para ejecutar dentro de Docker
    # Nota: He usado 'sqlcmd' a secas, si falla, usa '/opt/mssql-tools/bin/sqlcmd'
    comando = (
        f'docker exec -i {CONTAINER_NAME} '
        f'/opt/mssql-tools18/bin/sqlcmd -b -S localhost -U {ADMIN_USER} -P {ADMIN_PASS} -C -Q "{sql_query}"'
    )

    try:
        print(f"Restaurando base de datos '{DB_NAME}'...")
        subprocess.run(comando, shell=True, check=True)
        print(f" ¡Éxito! DB restaurada y usuario '{APP_USER}','{PHP_USER_1}','{PHP_USER_2}' vinculado.")
    except subprocess.CalledProcessError as e:
        print(f" Error en la ejecución.")
        print(f"Asegúrate de que el archivo {BACKUP_FILE} existe dentro del contenedor.")
        sys.exit(1)

if __name__ == "__main__":
    restaurar_base_de_datos()


