# script para monitorear la ram de mi pc

# Configuración de umbrales, intervalo y ruta de log
$UmbralPorcentaje = 75
$UmbralDisponibleGB = 3
$MargenReAlerta = 5 
$ArchivoLog = "log_memoria.txt"
$IntervaloSegundos = 5

$EnAlerta = $false 
$UltimoPorcentajeRegistrado = 0 

# Preparar objeto de notificación (No bloqueante)
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$Notification = New-Object System.Windows.Forms.NotifyIcon
$Notification.Icon = [System.Drawing.SystemIcons]::Warning # Icono de sistema
$Notification.Visible = $true

Write-Host "Monitoreo RAM iniciado (Notificaciones activas)..." -ForegroundColor Cyan
Write-Host "Registrando eventos en: $ArchivoLog `n"

while($true) {
    
    $OS = Get-CimInstance Win32_OperatingSystem
    $MemTotal = $OS.TotalVisibleMemorySize / 1KB
    $MemLibre = $OS.FreePhysicalMemory / 1KB
    $MemUsada = $MemTotal - $MemLibre
    
    $PorcentajeUso = [Math]::Round(($MemUsada / $MemTotal) * 100, 2)
    $LibreGB = [Math]::Round($MemLibre / 1024, 2)
    $Fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $CondicionCritica = ($PorcentajeUso -ge $UmbralPorcentaje -or $LibreGB -le $UmbralDisponibleGB)

    if ($CondicionCritica -and (-not $EnAlerta -or ($PorcentajeUso -ge ($UltimoPorcentajeRegistrado + $MargenReAlerta)))) {
        
        $Etiqueta = if (-not $EnAlerta) { "CRITICO" } else { "EMPEORANDO" }
        $EnAlerta = $true
        $UltimoPorcentajeRegistrado = $PorcentajeUso 
        
        $ProcesosCulpables = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 | 
                             Select-Object Name, @{Name="RAM(MB)"; Expression={[Math]::Round($_.WorkingSet64 / 1MB, 2)}}
        $TablaProcesos = $ProcesosCulpables | Out-String

        $LogMsg = "`n[$Fecha] >>> $Etiqueta - Uso de memoria al $PorcentajeUso% ($LibreGB GB libres)"
        $DetalleCulpables = "Procesos detectados:`n$TablaProcesos"

        # 1. Alerta en Consola
        Write-Host $LogMsg -ForegroundColor Red
        Write-Host $DetalleCulpables -ForegroundColor Yellow

        # 2. Guardar en Log
        $LogMsg | Out-File -FilePath $ArchivoLog -Append
        $DetalleCulpables | Out-File -FilePath $ArchivoLog -Append
        
        # 3. NOTIFICACIÓN DE GLOBO (No detiene el monitoreo)
        $Notification.BalloonTipTitle = "ALERTA RAM: $Etiqueta"
        $Notification.BalloonTipText = "Uso: $PorcentajeUso% | Disponible: $LibreGB GB"
        $Notification.ShowBalloonTip(3000) # Mostrar por 3 segundos
        
        [System.Console]::Beep(800, 500)
    } 
    elseif (-not $CondicionCritica -and $EnAlerta) {
        $EnAlerta = $false
        $UltimoPorcentajeRegistrado = 0
        $LogMsg = "`n[$Fecha] <<< SISTEMA RECUPERADO: Uso bajo al $PorcentajeUso% ($LibreGB GB libres)"
        
        Write-Host $LogMsg -ForegroundColor Green
        $LogMsg | Out-File -FilePath $ArchivoLog -Append
        "--------------------------------------------------" | Out-File -FilePath $ArchivoLog -Append

        # Notificar recuperación
        $Notification.BalloonTipTitle = "SISTEMA RECUPERADO"
        $Notification.BalloonTipText = "La RAM ha vuelto a niveles normales ($PorcentajeUso%)"
        $Notification.ShowBalloonTip(3000)
    }
    else {
        Write-Host -NoNewline "." 
    }

    Start-Sleep -Seconds $IntervaloSegundos
}