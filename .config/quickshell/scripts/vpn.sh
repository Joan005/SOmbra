#!/bin/sh
# Imprime: interfaz|ip de la primera VPN activa (tun*, wg*, ppp*), o nada si no hay.
ip -4 -o addr show 2>/dev/null | awk '$2 ~ /^(tun|wg|ppp)/ { split($4, a, "/"); print $2 "|" a[1]; exit }'
