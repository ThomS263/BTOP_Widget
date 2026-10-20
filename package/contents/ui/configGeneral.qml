import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Controls.ScrollView {
    id: scrollView
    clip: true
    contentWidth: availableWidth
    contentHeight: formLayout.implicitHeight

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
            Layout.fillWidth: true
        }

        Controls.ComboBox {
            id: profile
            Kirigami.FormData.label: i18n("Profile:")
            model: [i18n("Custom"), i18n("Minimal"), i18n("Hardware"), i18n("Performance"), i18n("Battery saver")]
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
