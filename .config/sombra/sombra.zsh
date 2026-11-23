# sombra.zsh: utilidades de auditoría de SOmbra (se carga desde ~/.zshrc)
# Uso exclusivo en laboratorios, CTF y equipos propios o con autorización por escrito.

SOMBRA_DIR="$HOME/.local/share/sombra"
export WL=/usr/share/wordlists          # diccionarios: $WL/rockyou.txt, $WL/seclists/...

# ---------- objetivo (lo lee también el chip TARGET de la barra) ----------
settarget() {
    [ -n "$1" ] || { echo "uso: settarget IP"; return 1; }
    mkdir -p "$SOMBRA_DIR"
    printf '%s\n' "$1" > "$SOMBRA_DIR/target"
    export TARGET="$1"
    echo "objetivo: $TARGET"
}
cleartarget() { rm -f "$SOMBRA_DIR/target"; unset TARGET; echo "objetivo borrado"; }

# Mantiene $TARGET al día en todas las terminales
_sombra_sync() { TARGET="$(cat "$SOMBRA_DIR/target" 2>/dev/null)"; export TARGET; }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _sombra_sync

# ---------- IP de la VPN (tun0, wg0...) ----------
vpnip() { ip -4 -o addr show 2>/dev/null | awk '$2 ~ /^(tun|wg|ppp)/ { split($4, a, "/"); print a[1]; exit }'; }
alias tun0='vpnip'

# ---------- servir ficheros y escuchar conexiones ----------
serve() {
    local port="${1:-8000}" ip; ip="$(vpnip)"
    echo "Sirviendo $(pwd) en el puerto $port${ip:+  ->  http://$ip:$port/}"
    python -m http.server "$port"
}
listen() {
    local port="${1:-4444}"
    if command -v rlwrap > /dev/null; then rlwrap ncat -lvnp "$port"; else ncat -lvnp "$port"; fi
}

# ---------- carpeta de trabajo para una máquina ----------
# mkctf nombre [IP]  ->  ~/ctf/nombre/{nmap,loot,exploits} + notas.md, y fija el objetivo
mkctf() {
    [ -n "$1" ] || { echo "uso: mkctf nombre [IP]"; return 1; }
    local d="$HOME/ctf/$1"
    mkdir -p "$d"/{nmap,loot,exploits}
    [ -f "$d/notas.md" ] || printf '# %s\n\n- IP: %s\n- Fecha: %s\n\n## Reconocimiento\n\n## Acceso\n\n## Escalada\n\n## Flags\n' \
        "$1" "${2:-?}" "$(date +%F)" > "$d/notas.md"
    cd "$d" || return
    [ -n "$2" ] && settarget "$2"
}

# ---------- reconocimiento rápido sobre $TARGET ----------
scan()     { [ -n "$TARGET" ] || { echo "Fije antes el objetivo: settarget IP"; return 1; }
             mkdir -p nmap; sudo nmap -sC -sV -oA nmap/inicial "$TARGET"; }
scanfull() { [ -n "$TARGET" ] || { echo "Fije antes el objetivo: settarget IP"; return 1; }
             mkdir -p nmap; sudo nmap -p- --min-rate 2000 -oA nmap/puertos "$TARGET"; }
webdirs()  { [ -n "$TARGET" ] || { echo "Fije antes el objetivo: settarget IP"; return 1; }
             ffuf -u "http://$TARGET${2:+:$2}/FUZZ" -w "${1:-$WL/seclists/Discovery/Web-Content/common.txt}"; }

# ---------- ayuda ----------
sombra() {
    cat << 'AYUDA'
  SOmbra · utilidades
    settarget IP / cleartarget   fija o borra el objetivo ($TARGET y chip de la barra)
    vpnip (tun0)                 IP de la VPN
    mkctf nombre [IP]            carpeta de trabajo con notas y objetivo
    scan / scanfull              nmap de servicios / de todos los puertos sobre $TARGET
    webdirs [lista] [puerto]     descubrimiento de rutas web con ffuf
    serve [puerto]               servidor HTTP en la carpeta actual (8000)
    listen [puerto]              escucha conexiones entrantes con ncat (4444)
    $WL                          /usr/share/wordlists
AYUDA
}
