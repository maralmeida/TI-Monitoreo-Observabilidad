#!/bin/bash

# --- 1. CONFIGURACIÓN ---
# Formato: "Nombre|IP|Puerto"
OBJETIVOS=("WEB_SERVER_APP|192.168.200.3|48002" "DB_SERVER_SQL|192.168.200.36|1433")
#variables globales
LOG_FOLDER="/var/log/monitorlb"
LOG_PATH="$LOG_FOLDER/log_disponibilidad.txt"
#EMAIL="maralmeida20@outlook.com"

# Parámetros de robustez
MAX_REINTENTOS=2   # Intentará 1 vez + 2 reintentos antes de fallar
TIMEOUT_SEG=5      # Cuánto tiempo esperar respuesta de la IP/Puerto
ESPERA_ENTRE_REINTENTOS=3

FECHA=$(date '+%Y-%m-%d %H:%M:%S')
mkdir -p "$LOG_FOLDER"
GLOBAL_STATUS=0
DETALLES_ERROR=""

#---2. inicio de monitoreo ---
echo "--- INICIANDO ESCANEO: $FECHA ---"

for fila in "${OBJETIVOS[@]}"; do
    IFS='|' read -r NOMBRE IP PUERTO <<< "$fila"
    
    EXITO=1 # Por defecto asumimos que falla (1) hasta que funcione (0)
    
    # --- 2. LÓGICA DE REINTENTOS ---
    for (( i=0; i<=$MAX_REINTENTOS; i++ )); do
        # PASO 1: PING y PASO 2: Puerto (combinados para eficiencia)
        if ping -c 1 -W $TIMEOUT_SEG "$IP" > /dev/null 2>&1 && \
           nc -z -w $TIMEOUT_SEG "$IP" "$PUERTO" > /dev/null 2>&1; then
            EXITO=0
            break # Si funciona, salimos del bucle de reintentos
        else
            echo "$FECHA - [!] Intento $((i+1)) fallido para $NOMBRE. Reintentando..." >> "$LOG_PATH"
            sleep $ESPERA_ENTRE_REINTENTOS
        fi
    done

    # --- 3. RESULTADO FINAL DEL OBJETIVO ---
    if [ $EXITO -eq 0 ]; then
        echo -e "[*] $NOMBRE ($IP): \e[32mOK\e[0m"
        echo "$FECHA - INFO - $NOMBRE ($IP) operativo en puerto $PUERTO" >> "$LOG_PATH"
    else
        echo -e "[*] $NOMBRE ($IP): \e[31mFALLO DEFINITIVO\e[0m"
        MSG="ALERTA: $NOMBRE ($IP) no disponible tras $((MAX_REINTENTOS+1)) intentos."
        echo "$FECHA - CRITICO - $MSG" >> "$LOG_PATH"
        DETALLES_ERROR+="- $MSG\n"
        GLOBAL_STATUS=1
    fi
done

# --- 4. ENVÍO DE CORREO SI HAY FALLO ---
#if [ $GLOBAL_STATUS -ne 0 ]; then
 #   echo -e "Se han detectado fallos en los servidores de producción:\n\n$DETALLES_ERROR" | mail -s "ALERTA MONITOREO: Fallo en Infraestructura" $EMAIL
#fi

# --- 5. MARCA "ESTOY VIVO" (HEARTBEAT) ---
# Esto sirve para confirmar que el script corrió sin trabarse
echo "$FECHA - HEARTBEAT - Script ejecutado correctamente" >> "$LOG_PATH"

exit $GLOBAL_STATUS