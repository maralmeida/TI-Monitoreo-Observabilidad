import os
import subprocess
from datetime import datetime, timedelta

# --- CONFIGURACIÓN ---
DB_NAME = "SitioPruebas"
BACKUP_PATH = r"C:\respaldobd"  # Usa la 'r' para rutas de Windows
DB_USER = "respaldabd"
DB_PASS = "respaldabd"
RETENTION_DAYS = 7

def realizar_respaldo():
    # Crear carpeta si no existe
    if not os.path.exists(BACKUP_PATH):
        os.makedirs(BACKUP_PATH)

    # Nombre del archivo con fecha y hora
    timestamp = datetime.now().strftime("%Y-%m-%d_%H%M")
    filename = f"{DB_NAME}_{timestamp}.bak"
    full_path = os.path.join(BACKUP_PATH, filename)

    # Comando SQL (con compresión para que no pese)
    sql_query = f"BACKUP DATABASE [{DB_NAME}] TO DISK = N'{full_path}' WITH COMPRESSION, STATS = 10"
    
    # Ejecución mediante sqlcmd
    comando = f'sqlcmd -S localhost -U {DB_USER} -P {DB_PASS} -Q "{sql_query}"'
    
    try:
        # Agregamos -b para que sqlcmd devuelva un error si falla el SQL
        comando = f'sqlcmd -b -S localhost -U {DB_USER} -P {DB_PASS} -Q "{sql_query}"'
        subprocess.run(comando, shell=True, check=True)
        print(f"✅ Respaldo exitoso: {filename}")
    except subprocess.CalledProcessError:
        print(f"❌ Error: El usuario no tiene permisos o el disco está lleno.")

def limpiar_antiguos():
    print("Limpiando archivos antiguos...")
    limite = datetime.now() - timedelta(days=RETENTION_DAYS)
    
    for archivo in os.listdir(BACKUP_PATH):
        ruta_archivo = os.path.join(BACKUP_PATH, archivo)
        if os.path.isfile(ruta_archivo):
            fecha_creacion = datetime.fromtimestamp(os.path.getctime(ruta_archivo))
            if fecha_creacion < limite and archivo.endswith(".bak"):
                os.remove(ruta_archivo)
                print(f"🗑️ Borrado por antigüedad: {archivo}")

if __name__ == "__main__":
    realizar_respaldo()
    limpiar_antiguos()