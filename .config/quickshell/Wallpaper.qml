import Quickshell
import Quickshell.Wayland
import QtQuick
		
PanelWindow {
	WlrLayershell.layer: WlrLayer.Background
	WlrLayershell.namespace: "wallpaper"
	exclusionMode: ExclusionMode.Ignore
	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	color: "#07080d"

	Image {
		anchors.fill: parent
		source: Qt.resolvedUrl("wallpaper.png")
		fillMode: Image.PreserveAspectCrop
		asynchronous: true
	}	
}
