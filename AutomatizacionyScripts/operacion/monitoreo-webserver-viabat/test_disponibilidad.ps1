$IP = "192.168.200.3"
$Port = 48002
# Usamos comillas dobles para rutas con caracteres especiales
$LogPath = "C:\Users\USER\Documents\recursosgithub\MonitoreoyObservabilidad\TI-Monitoreo-Observabilidad\AutomatizacionyScripts\operacion\monitoreo-webserver-viabat\Logs_disponibilidad.txt"
$Fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# --- MEJORA PROACTIVA: Verificar si la carpeta existe ---
$LogDir = Split-Path $LogPath
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# 1. Prueba de Red (Ping)
# Usamos -Count 1 para que sea una revisión rápida de un solo paquete
if (Test-Connection -ComputerName $IP -Count 1 -Quiet) {
    $msgRed = "INFO - Servidor Fisico Online"
    Write-Host $msgRed -ForegroundColor Green
    "$Fecha - $msgRed" | Out-File $LogPath -Append
} else {
    $msgRed = "CRITICO - Servidor Fisico Offline"
    Write-Host $msgRed -ForegroundColor Red
    "$Fecha - $msgRed" | Out-File $LogPath -Append
}

# 2. Prueba de Aplicación
# Intentamos la conexión al puerto específico
try {
    $test = Test-NetConnection -ComputerName $IP -Port $Port -WarningAction SilentlyContinue
    if ($test.TcpTestSucceeded) {
        $msgApp = "INFO - Aplicacion escuchando en puerto $Port"
        Write-Host $msgApp -ForegroundColor Green
        "$Fecha - $msgApp" | Out-File $LogPath -Append
    } else {
        $msgApp = "CRITICO - Puerto $Port inaccesible (Revisar Firewall o Pool de IIS)"
        Write-Host $msgApp -ForegroundColor Yellow
        "$Fecha - $msgApp" | Out-File $LogPath -Append
    }
} catch {
    "$Fecha - ERROR de ejecucion en el test de puerto" | Out-File $LogPath -Append
}



