# 🕶️ SOmbra

> **S**istema **O**perativo con nombre de hacker: la **O** mayúscula es un guiño a su hermano [PikSOn](https://github.com/Joan005/PikSOn).

Un entorno de **ciberseguridad sobre Arch Linux + Hyprland + Quickshell**: lo que da Kali (las herramientas), con un escritorio cuidado. Es el hermano oscuro de [PikSOn](https://github.com/Joan005/PikSOn): la misma base, otra paleta y una barra pensada para auditar.

> ⚖️ **Uso responsable.** Todo lo que instala este repositorio es para **aprendizaje, laboratorios, retos CTF y equipos propios o con autorización por escrito**. Usar estas herramientas contra sistemas ajenos sin permiso es delito.

---

## 📑 Índice
1. [Instalación](#instalacion)
2. [Qué es](#que-es)
3. [La barra de auditoría](#barra)
4. [La terminal](#terminal)
5. [Herramientas](#herramientas)
6. [Atajos de teclado](#atajos)
7. [Estructura del repositorio](#estructura)
8. [Pendiente](#pendiente)

---

<a id="instalacion"></a>
## 1. Instalación

Se hace igual que con PikSOn: **instalar Arch con `archinstall`** (perfil mínimo, NetworkManager, usuario con `sudo` y los paquetes adicionales `git nano base-devel`). Después:

```bash
git clone https://github.com/Joan005/SOmbra
cd SOmbra
bash install.sh --vm        # o --real en un equipo físico
```

| Opción | Efecto |
|---|---|
| `--vm` / `--real` | Tipo de equipo: máquina virtual o equipo físico |
| `--dry-run` | Muestra lo que haría, sin cambiar nada |
| `--all` | Instala todas las aplicaciones y categorías de herramientas |
| `--minimal` | Solo la base, sin aplicaciones ni herramientas |
| `--apps brave,web,wifi` | Solo esas aplicaciones y categorías |
| *(ninguna de las tres anteriores)* | Muestra un menú para elegir |

En una VM de VirtualBox, active antes **VMSVGA + aceleración 3D + 128 MB de vídeo**, como en PikSOn.

### Qué hace el script (11 pasos)

1. Actualiza el sistema.
2. Instala `yay` (AUR).
3. Añade el repositorio **BlackArch**: descarga `strap.sh`, muestra su **sha1** y solo lo ejecuta si usted confirma que coincide con el publicado en [blackarch.org/downloads](https://blackarch.org/downloads.html). Sin terminal, puede pasarse con `BLACKARCH_SHA1=... bash install.sh ...`.
4. Instala la base (`pkglist.txt` y `aur-pkglist.txt`).
5. Instala las **categorías de herramientas** elegidas (`herramientas.txt`).
6. Copia la configuración (con copia de seguridad en `~/.config-backup-FECHA`).
7. Activa NetworkManager y PipeWire.
8. Zona horaria y zsh.
9. Ajustes de VM o equipo real.
10. Aspecto GTK.
11. Entorno de auditoría: `~/ctf`, `~/capturas`, grupo `wireshark` y los diccionarios en **`/usr/share/wordlists`**, como en Kali (`rockyou.txt` y `seclists/`).

Registro completo en `~/sombra-install.log`.

**Después, a mano:** reiniciar; `msfdb init` para la base de datos de Metasploit; y para Wi-Fi, una **tarjeta USB con modo monitor** (en una VM, pásela a la máquina virtual desde VirtualBox).

---

<a id="que-es"></a>
## 2. Qué es

¿Kali es solo Linux con herramientas? **En lo esencial, sí.** SOmbra toma Arch, añade el repositorio **BlackArch** (miles de herramientas) e instala solo las categorías que usted elige, en lugar de todo el catálogo. Así el sistema no se vuelve frágil.

**La estética** se llama *Señal fantasma*: futurista y minimalista.

| Color | Uso |
|---|---|
| `#07080d` / `#0a0c12` | Fondo: negro profundo |
| `#e6edf3` | Texto |
| `#c04cfd` | Violeta eléctrico: foco y selección |
| `#00e5ff` | Cian: datos y enlaces |
| `#ff2e4d` | Rojo: objetivo y alertas |
| `#39ff9f` | Verde terminal: VPN conectada |

Esquinas casi rectas, líneas finas, una sola tipografía (JetBrains Mono Nerd Font) y un fondo propio: rejilla hexagonal tenue, líneas de escaneo y resplandores violeta y cian.

---

<a id="barra"></a>
## 3. La barra de auditoría

Es la barra de PikSOn (música, calendario, sonido, avisos, tiempo, red, pantallas y apagado) con dos chips nuevos a la izquierda:

| Chip | Qué muestra | Clic | Clic derecho |
|---|---|---|---|
| 🔒 **VPN** | Interfaz e IP del túnel (`tun0`, `wg0`...), en verde si está conectada | Copia la IP | — |
| 🎯 **Objetivo** | La IP fijada con `settarget`, en rojo | Copia la IP | Borra el objetivo |

Los escritorios se muestran como `01` a `05`, y la línea inferior pasa de violeta a cian.

---

<a id="terminal"></a>
## 4. La terminal

kitty + zsh + **starship** con un prompt de dos líneas que muestra siempre **la IP de la VPN y el objetivo**. Escriba `sombra` para ver las utilidades:

| Orden | Qué hace |
|---|---|
| `settarget IP` / `cleartarget` | Fija o borra el objetivo: la variable `$TARGET` en todas las terminales y el chip de la barra |
| `vpnip` (o `tun0`) | IP de la VPN |
| `mkctf nombre [IP]` | Crea `~/ctf/nombre/{nmap,loot,exploits}` con `notas.md` y fija el objetivo |
| `scan` / `scanfull` | `nmap` de servicios / de todos los puertos sobre `$TARGET` |
| `webdirs [lista] [puerto]` | Descubrimiento de rutas web con `ffuf` |
| `serve [puerto]` | Servidor HTTP en la carpeta actual (8000), mostrando la URL con la IP de la VPN |
| `listen [puerto]` | Escucha conexiones con `ncat` (4444) |
| `$WL` | `/usr/share/wordlists` |

---

<a id="herramientas"></a>
## 5. Herramientas

Se eligen por categorías en el instalador. Para añadir una, basta con una línea en `herramientas.txt`.

| Categoría | Incluye |
|---|---|
| `web` | nmap, Wireshark, Burp Suite, ffuf, gobuster, feroxbuster, sqlmap, nikto, whatweb, wfuzz |
| `redes` | Metasploit, NetExec, Impacket, smbclient, enum4linux-ng, Responder, masscan, tcpdump, proxychains-ng, socat |
| `diccionarios` | SecLists y rockyou |
| `claves` | John, Hashcat, Hydra, hashid, CeWL, crunch |
| `wifi` | aircrack-ng, hcxtools, hcxdumptool, bettercap, reaver, wifite, macchanger, iw |

La base incluye además `openvpn`, `wireguard-tools`, `tmux`, `rlwrap`, `wl-clipboard`, `grim`/`slurp`, `bind` (dig), `whois`, `jq` y `hyprpolkitagent`.

> 💡 Si un paquete falla, el instalador sigue con los demás y lo apunta en la lista de avisos final.

---

<a id="atajos"></a>
## 6. Atajos de teclado

Los de PikSOn, más estos:

| Atajo | Acción |
|---|---|
| `Super + T` | Terminal con la sesión de tmux `ctf` |
| `Super + U` | Burp Suite |
| `Super + W` | Wireshark |
| `Impr` | Captura de una zona, al portapapeles |
| `Shift + Impr` | Captura de una zona, a `~/capturas` |

---

<a id="estructura"></a>
## 7. Estructura del repositorio

```
SOmbra/
├── install.sh / ui.sh       # Instalador (11 pasos) y su portada
├── pkglist.txt              # Base: escritorio y utilidades
├── aur-pkglist.txt          # AUR
├── opcionales.txt           # Aplicaciones opcionales
├── herramientas.txt         # Categorías de herramientas de auditoría
├── zsh/                     # .zshrc (carga sombra.zsh) y .zprofile
└── .config/
    ├── starship.toml        # Prompt con VPN y objetivo
    ├── sombra/sombra.zsh   # Utilidades: settarget, mkctf, scan, serve...
    ├── hypr/                # Hyprland y hyprlock
    ├── kitty/               # Terminal (Señal fantasma)
    ├── gtk-3.0/             # Thunar y apps GTK
    └── quickshell/          # Barra, paneles, dock, tema y fondo
        └── scripts/vpn.sh   # IP de la VPN para el chip
```

---

<a id="pendiente"></a>
## 8. Pendiente

- [ ] **Probar `install.sh` en una VM limpia** (de momento solo se ha probado con `--dry-run`)
- [ ] Panel del **objetivo**: notas rápidas por máquina y puertos abiertos leídos del último `nmap`
- [ ] **Lanzador de herramientas** por categorías
- [ ] Chip de **modo monitor** del Wi-Fi (interfaz y canal)
- [ ] Perfil de **Firefox** para auditoría (FoxyProxy hacia Burp y su certificado)
- [ ] Revisar en la VM qué paquetes de BlackArch fallan y ajustar `herramientas.txt`
- [ ] Aislamiento respecto a PikSOn en el arranque dual (LUKS, EFI propia o disco aparte), como se describe en el README de PikSOn
