import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root
    implicitWidth: 640
    implicitHeight: 560
    property string title: ""
    property alias cfg_layoutMode: layoutMode.currentIndex
    property alias cfg_panelOrder: panelOrder.currentIndex
    property alias cfg_chartStyle: chartStyle.currentIndex
    property alias cfg_graphZoom: graphZoom.currentIndex
    property alias cfg_colorScheme: colorScheme.currentIndex
    property alias cfg_panelOpacity: panelOpacity.value
    property alias cfg_fontScale: fontScale.value
    property alias cfg_panelSpacing: panelSpacing.value
    property var cfg_updateInterval
    property var cfg_showBattery
    property var cfg_showCpu
    property var cfg_showMemory
    property var cfg_showNetwork
    property var cfg_showDisk
    property var cfg_showPrograms
    property var cfg_historyLength
    property var cfg_networkInterface
    property var cfg_processCount
    property var cfg_processSort
    property var cfg_fanSpeedTarget
    property var cfg_profile
    property var cfg_showHardware
    property var cfg_showDisks
    property var cfg_showNetworkDetails
    property var cfg_privacyMode
    property var cfg_temperatureWarning
    property var cfg_uiVersion
    property var cfg_updateIntervalDefault
    property var cfg_showBatteryDefault
    property var cfg_showCpuDefault
    property var cfg_showMemoryDefault
    property var cfg_showNetworkDefault
    property var cfg_showDiskDefault
    property var cfg_showProgramsDefault
    property var cfg_layoutModeDefault
    property var cfg_chartStyleDefault
    property var cfg_panelOrderDefault
    property var cfg_historyLengthDefault
    property var cfg_networkInterfaceDefault
    property var cfg_processCountDefault
    property var cfg_processSortDefault
    property var cfg_fanSpeedTargetDefault
    property var cfg_panelOpacityDefault
    property var cfg_fontScaleDefault
    property var cfg_panelSpacingDefault
    property var cfg_profileDefault
    property var cfg_colorSchemeDefault
    property var cfg_showHardwareDefault
    property var cfg_showDisksDefault
    property var cfg_graphZoomDefault
    property var cfg_showNetworkDetailsDefault
    property var cfg_privacyModeDefault
    property var cfg_temperatureWarningDefault
    property var cfg_uiVersionDefault

    function resetPage() {
        layoutMode.currentIndex = 0
        panelOrder.currentIndex = 0
        chartStyle.currentIndex = 0
        graphZoom.currentIndex = 0
        colorScheme.currentIndex = 0
        panelOpacity.value = 19
        fontScale.value = 100
        panelSpacing.value = 8
    }

    Controls.ScrollView {
        id: scrollView
        Layout.fillWidth: true
        Layout.fillHeight: true
        implicitHeight: root.implicitHeight
        clip: true
        contentWidth: availableWidth
        contentHeight: formLayout.implicitHeight

        Kirigami.FormLayout {
            id: formLayout
            width: scrollView.availableWidth
            implicitHeight: childrenRect.height + Kirigami.Units.largeSpacing

        Controls.ComboBox { id: layoutMode; Kirigami.FormData.label: i18n("Panel layout:"); model: [i18n("Shell grid (2 x 2)"), i18n("Single column"), i18n("Wide network panel")] }
        Controls.ComboBox { id: panelOrder; Kirigami.FormData.label: i18n("Panel order:"); model: [i18n("CPU, memory, network, disk"), i18n("Network first"), i18n("Memory first"), i18n("Disk first")] }
        Controls.ComboBox { id: chartStyle; Kirigami.FormData.label: i18n("Graph style:"); model: [i18n("Lines"), i18n("Bars"), i18n("Blocks / steps"), i18n("Dots")] }
        Controls.ComboBox { id: graphZoom; Kirigami.FormData.label: i18n("Graph zoom:"); model: [i18n("Fit all values"), i18n("2x"), i18n("4x")] }
        Controls.ComboBox { id: colorScheme; Kirigami.FormData.label: i18n("Color scheme:"); model: [i18n("KDE / blue"), i18n("btop / green"), i18n("Amber")] }

        Controls.SpinBox { id: panelOpacity; Kirigami.FormData.label: i18n("Panel opacity:"); from: 5; to: 70; editable: true; textFromValue: function(value) { return i18n("%1%", value); } }
        Controls.SpinBox { id: fontScale; Kirigami.FormData.label: i18n("Font scale:"); from: 80; to: 130; stepSize: 5; editable: true; textFromValue: function(value) { return i18n("%1%", value); } }
        Controls.SpinBox { id: panelSpacing; Kirigami.FormData.label: i18n("Panel spacing:"); from: 2; to: 20; editable: true; textFromValue: function(value) { return i18n("%1 px", value); } }

        Controls.Button {
            Kirigami.FormData.label: i18n("Defaults:")
            text: i18n("Restore display defaults")
            onClicked: root.resetPage()
        }
        }
    }
}
