#!/bin/bash
# ##############################################################################
# Script de Monitoreo de Memoria RAM - Versión Unificada Producción
# ##############################################################################

# --- CONFIGURACIÓN ---
UMBRAL_PORCENTAJE=75
UMBRAL_CRITICO=90
UMBRAL_DISPONIBLE_MB=1024
ARCHIVO_LOG="/var/log/monitorlb/ram_monitor.log"
ARCHIVO_CONTADOR="/tmp/.ram_alerta_cont" # Mantiene el conteo para "En aumento"

# 1. Obtener métricas de memoria
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_DISPONIBLE=$(free -m | awk '/^Mem:/{print $7}')
MEM_USADA=$((MEM_TOTAL - MEM_DISPONIBLE))

# 2. Cálculos de Porcentajes
PORCENTAJE_USO=$(echo "scale=2; ($MEM_USADA / $MEM_TOTAL) * 100" | bc)
PORCENTAJE_LIBRE=$(echo "scale=2; ($MEM_DISPONIBLE / $MEM_TOTAL) * 100" | bc)
PORCENTAJE_INT=${PORCENTAJE_USO%.*}

MEM_USADA_GB=$(echo "scale=2; $MEM_USADA / 1024" | bc)
MEM_LIBRE_GB=$(echo "scale=2; $MEM_DISPONIBLE / 1024" | bc)

FECHA=$(date "+%Y-%m-%d %H:%M:%S")

# Cargar contador previo para saber si el consumo persiste
[ -f $ARCHIVO_CONTADOR ] && CONTADOR=$(cat $ARCHIVO_CONTADOR) || CONTADOR=0

# --- 3. REGISTRO OBLIGATORIO EN LOG  ---
echo "--------------------------------------------------" >> "$ARCHIVO_LOG"
echo "[$FECHA] ESTADO: Uso $PORCENTAJE_USO% (${MEM_USADA_GB}GB) | Libre ${MEM_LIBRE_GB}GB" >> "$ARCHIVO_LOG"

# --- 4. SALIDA PARA GITHUB ACTIONS (Tu consola original) ---
echo "=========================================="
echo "ESTADO DE MEMORIA ACTUAL"
echo "=========================================="
echo "Fecha:        $FECHA"
echo "Total RAM:    ${MEM_TOTAL} MB ($(echo "scale=2; $MEM_TOTAL / 1024" | bc) GB)"
echo "Uso:          $PORCENTAJE_USO% (${MEM_USADA_GB} GB)"
echo "Libre:        $PORCENTAJE_LIBRE% (${MEM_LIBRE_GB} GB)"
echo "Alerta:       $UMBRAL_PORCENTAJE% "
echo "=========================================="

# --- 5. LÓGICA DE ALERTA PROGRESIVA (3 niveles ) ---
if [ "$PORCENTAJE_INT" -ge "$UMBRAL_CRITICO" ]; then
    # NIVEL: CRITICO (90%+)
    echo "Aumento CRITICA de consumo de memoria detectado..."
    echo ">>> [CRITICO] CONSUMO DE MEMORIA: $PORCENTAJE_INT%" >> "$ARCHIVO_LOG"
    echo 0 > $ARCHIVO_CONTADOR # Reiniciamos para el siguiente ciclo
    DETALLE_PROCESOS=true

elif [ "$PORCENTAJE_INT" -ge "$UMBRAL_PORCENTAJE" ]; then
    # NIVEL: ALERTA (75%+)
    CONTADOR=$((CONTADOR + 1))
    echo $CONTADOR > $ARCHIVO_CONTADOR
    
    if [ "$CONTADOR" -ge 3 ]; then
        # Si se detecta por 3ra vez consecutiva
        echo ">>> [ALERTA] CONSUMO: EN AUMENTO ($PORCENTAJE_INT%)" >> "$ARCHIVO_LOG"
    else
        # 1ra o 2da detección
        echo ">>> [ALERTA] CONSUMO DE MEMORIA: $PORCENTAJE_INT%" >> "$ARCHIVO_LOG"
    fi
    DETALLE_PROCESOS=true
    echo "ALERTA DE CONSUMO Registrando procesos con mayor consumo..."
else
    # NIVEL: NORMAL
    echo 0 > $ARCHIVO_CONTADOR
    DETALLE_PROCESOS=false
    echo "✅ El uso de memoria está dentro de los niveles normales - Uso $PORCENTAJE_USO%."
fi

# --- 6. REGISTRO DE PROCESOS (Si hay alerta) ---
if [ "$DETALLE_PROCESOS" = true ]; then
    PROCESOS_CULPABLES=$(ps -eo comm,rsz --sort=-rsz | head -n 6 | awk '{if(NR>1) print $1 " (" $2/1024 " MB)"}')
    echo "Top Procesos:" >> "$ARCHIVO_LOG"
    echo "$PROCESOS_CULPABLES" >> "$ARCHIVO_LOG"
    
    # Log del sistema (Tu logger original)
    logger -p user.crit "RAM Monitor: Alerta detectada: $PORCENTAJE_USO% ."
fi





