pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // Señal fantasma: negro profundo, violeta eléctrico, cian y rojo de alerta

    // colores
    readonly property color bgChip: "#e60c0e16"
    readonly property color bgPopup: "#f50c0e16"
    readonly property color bgCell: "#80161a28"
    readonly property color line: "#2a3350"
    readonly property color fg: "#e6edf3"
    readonly property color fgMuted: "#7d8aa6"
    readonly property color accent: "#c04cfd"     // violeta: foco, selección
    readonly property color accent2: "#00e5ff"    // cian: datos, enlaces
    readonly property color alert: "#ff2e4d"      // rojo: objetivo, avisos críticos
    readonly property color ok: "#39ff9f"         // verde terminal: conectado
    readonly property color fgOnAccent: "#07080d"

    // formas: esquinas casi rectas, estilo minimalista
    readonly property int radius: 6
    readonly property int radiusSmall: 3

    // tipografías
    readonly property string fontSerif: "JetBrainsMono Nerd Font"
    readonly property string fontUi: "JetBrainsMono Nerd Font"
    readonly property string fontIcons: "JetBrainsMono Nerd Font"

    // tamaños
    readonly property int sizeText: 12
    readonly property int sizeClock: 15
    readonly property int chipHeight: 28
}
