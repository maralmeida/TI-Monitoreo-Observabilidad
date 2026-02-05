#!/bin/bash

# --- 1. CONFIGURACIÓN ---
# Formato: "Nombre|IP|Puerto"
OBJETIVOS=("WEB_SERVER_APP|192.168.200.3|48002" "DB_SERVER_SQL|192.168.200.36|1433")

LOG_FOLDER="/var/log/monitorlb"
LOG_PATH="$LOG_FOLDER/log_disponibilidad.txt"
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_FOLDER"

GLOBAL_STATUS=0 # 0 es OK en Linux

echo "--- INICIANDO ESCANEO ---"

for fila in "${OBJETIVOS[@]}"; do
    # Separar los datos
    IFS='|' read -r NOMBRE IP PUERTO <<< "$fila"
    
    echo -n "[*] Analizando $NOMBRE ($IP)... "

    # PASO 1: PING (1 solo paquete, espera 2 segundos)
    if ping -c 1 -W 2 "$IP" > /dev/null 2>&1; then
        
        # PASO 2: Valida Puerto (usando el comando 'nc' o netcat)
        if nc -z -w 2 "$IP" "$PUERTO" > /dev/null 2>&1; then
            echo -e "\e[32mOK: Puerto $PUERTO disponible\e[0m"
            echo "$FECHA - INFO - $NOMBRE ($IP) operativo en puerto $PUERTO" >> "$LOG_PATH"
        else
            echo -e "\e[33mALERTA: Puerto $PUERTO CERRADO\e[0m"
            echo "$FECHA - ALERTA - $NOMBRE - IP responde pero PUERTO $PUERTO inaccesible" >> "$LOG_PATH"
            GLOBAL_STATUS=1
        fi
    else
        echo -e "\e[31mFALLO: IP no responde\e[0m"
        echo "$FECHA - CRITICO - $NOMBRE - IP $IP no responde" >> "$LOG_PATH"
        GLOBAL_STATUS=1
    fi
done

exit $GLOBAL_STATUS