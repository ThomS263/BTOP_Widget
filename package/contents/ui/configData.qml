import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root
    implicitWidth: 640
    implicitHeight: 560
    property string title: ""
    property alias cfg_historyLength: historyLength.currentIndex
    property alias cfg_networkInterface: networkInterface.text
    property alias cfg_processCount: processCount.value
    property alias cfg_processSort: processSort.currentIndex
    property alias cfg_fanSpeedTarget: fanSpeedTarget.value
    property alias cfg_showNetworkDetails: showNetworkDetails.checked
    property var cfg_updateInterval
    property var cfg_showBattery
    property var cfg_showCpu
    property var cfg_showMemory
    property var cfg_showNetwork
    property var cfg_showDisk
    property var cfg_showPrograms
    property var cfg_layoutMode
    property var cfg_chartStyle
    property var cfg_panelOrder
    property var cfg_panelOpacity
    property var cfg_fontScale
    property var cfg_panelSpacing
    property var cfg_profile
    property var cfg_colorScheme
    property var cfg_showHardware
    property var cfg_showDisks
    property var cfg_graphZoom
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
        historyLength.currentIndex = 0
        networkInterface.text = ""
        processCount.value = 5
        processSort.currentIndex = 0
        fanSpeedTarget.value = 0
        showNetworkDetails.checked = true
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

        Controls.ComboBox { id: historyLength; Kirigami.FormData.label: i18n("Graph history:"); model: [i18n("20 samples"), i18n("40 samples"), i18n("80 samples")] }
        Controls.TextField { id: networkInterface; Kirigami.FormData.label: i18n("Network interface:"); placeholderText: i18n("Auto / all interfaces"); selectByMouse: true }
        Controls.SpinBox { id: processCount; Kirigami.FormData.label: i18n("Processes shown:"); from: 3; to: 10; editable: true }
        Controls.ComboBox { id: processSort; Kirigami.FormData.label: i18n("Sort processes by:"); model: [i18n("CPU"), i18n("Memory"), i18n("Name")] }
        Controls.CheckBox { id: showNetworkDetails; Kirigami.FormData.label: i18n("Network:"); text: i18n("Show interface state, IP and signal") }

        Controls.Slider {
            id: fanSpeedTarget
            Kirigami.FormData.label: i18n("Fan target hint:")
            from: 0
            to: 100
            stepSize: 5
            value: 0
            live: true
        }

        Controls.Label {
            Kirigami.FormData.label: ""
            text: fanSpeedTarget.value === 0
                  ? i18n("Automatic / monitoring only")
                  : i18n("Display hint: %1% (no hardware control is performed)", fanSpeedTarget.value)
            color: Kirigami.Theme.disabledTextColor
            wrapMode: Text.WordWrap
        }

        Controls.Label {
            Kirigami.FormData.label: ""
            text: i18n("Empty interface combines active links. Fan target is a read-only hint unless hardware control is supported.")
            color: Kirigami.Theme.disabledTextColor
            wrapMode: Text.WordWrap
        }

        Controls.Button {
            Kirigami.FormData.label: i18n("Defaults:")
            text: i18n("Restore data defaults")
            onClicked: root.resetPage()
        }
        }
    }
}
