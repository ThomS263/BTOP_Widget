import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root
    implicitWidth: 640
    implicitHeight: 560
    property string title: ""
    property alias cfg_updateInterval: updateInterval.value
    property alias cfg_profile: profile.currentIndex
    property alias cfg_showBattery: showBattery.checked
    property alias cfg_showCpu: showCpu.checked
    property alias cfg_showMemory: showMemory.checked
    property alias cfg_showNetwork: showNetwork.checked
    property alias cfg_showDisk: showDisk.checked
    property alias cfg_showPrograms: showPrograms.checked
    property alias cfg_showHardware: showHardware.checked
    property alias cfg_showDisks: showDisks.checked
    property alias cfg_privacyMode: privacyMode.checked
    property alias cfg_temperatureWarning: temperatureWarning.value
    property alias cfg_uiVersion: uiVersion.currentIndex
    property var cfg_layoutMode
    property var cfg_chartStyle
    property var cfg_panelOrder
    property var cfg_historyLength
    property var cfg_networkInterface
    property var cfg_processCount
    property var cfg_processSort
    property var cfg_fanSpeedTarget
    property var cfg_panelOpacity
    property var cfg_fontScale
    property var cfg_panelSpacing
    property var cfg_colorScheme
    property var cfg_graphZoom
    property var cfg_showNetworkDetails
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

        Controls.SpinBox {
            id: updateInterval
            Kirigami.FormData.label: i18n("Update interval:")
            from: 250
            to: 10000
            stepSize: 250
            editable: true
            textFromValue: function(value) { return i18n("%1 ms", value); }
            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text.replace(/[^0-9]/g, ""));
            }
        }

        Controls.Label {
            Kirigami.FormData.label: ""
            text: i18n("The dashboard stays visible and updates continuously.")
            color: Kirigami.Theme.disabledTextColor
            wrapMode: Text.WordWrap
        }

        Controls.ComboBox {
            id: profile
            Kirigami.FormData.label: i18n("Profile:")
            model: [i18n("Custom"), i18n("Minimal"), i18n("Hardware"), i18n("Performance"), i18n("Battery saver")]
        }

        Controls.ComboBox {
            id: uiVersion
            Kirigami.FormData.label: i18n("UI version:")
            model: [i18n("Current dashboard"), i18n("Widget 1 / classic")]
        }

        Controls.CheckBox { id: showBattery; Kirigami.FormData.label: i18n("Show:"); text: i18n("Battery, watts and voltage") }
        Controls.CheckBox { id: showCpu; Kirigami.FormData.label: ""; text: i18n("CPU") }
        Controls.CheckBox { id: showMemory; Kirigami.FormData.label: ""; text: i18n("Memory and swap") }
        Controls.CheckBox { id: showNetwork; Kirigami.FormData.label: ""; text: i18n("Network") }
        Controls.CheckBox { id: showDisk; Kirigami.FormData.label: ""; text: i18n("Disk and load") }
        Controls.CheckBox { id: showPrograms; Kirigami.FormData.label: ""; text: i18n("Top programs") }
        Controls.CheckBox { id: showHardware; Kirigami.FormData.label: ""; text: i18n("GPU, temperatures and fans") }
        Controls.CheckBox { id: showDisks; Kirigami.FormData.label: ""; text: i18n("Additional disks") }
        Controls.SpinBox { id: temperatureWarning; Kirigami.FormData.label: i18n("Temperature warning:"); from: 60; to: 110; stepSize: 5; editable: true; textFromValue: function(value) { return i18n("%1 °C", value); } }
        Controls.CheckBox { id: privacyMode; Kirigami.FormData.label: i18n("Privacy:"); text: i18n("Hide interface names and IP addresses") }
        }
    }
}
