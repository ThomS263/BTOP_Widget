import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    property alias cfg_historyLength: historyLength.currentIndex
    property alias cfg_networkInterface: networkInterface.text
    property alias cfg_processCount: processCount.value
    property alias cfg_processSort: processSort.currentIndex
    property alias cfg_fanSpeedTarget: fanSpeedTarget.value

    Controls.ComboBox { id: historyLength; Kirigami.FormData.label: i18n("Graph history:"); model: [i18n("20 samples"), i18n("40 samples"), i18n("80 samples")] }
    Controls.TextField { id: networkInterface; Kirigami.FormData.label: i18n("Network interface:"); placeholderText: i18n("Auto / all interfaces"); selectByMouse: true }
    Controls.SpinBox { id: processCount; Kirigami.FormData.label: i18n("Processes shown:"); from: 3; to: 10; editable: true }
    Controls.ComboBox { id: processSort; Kirigami.FormData.label: i18n("Sort processes by:"); model: [i18n("CPU"), i18n("Memory"), i18n("Name")] }

    Controls.Slider {
        id: fanSpeedTarget
        Kirigami.FormData.label: i18n("Fan target hint:")
        from: 0
        to: 100
        stepSize: 5
        value: 0
        live: true
        Layout.fillWidth: true
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
        text: i18n("Leave the interface empty to combine all active interfaces. The fan value is read-only unless your system exposes a supported controller.")
        color: Kirigami.Theme.disabledTextColor
        wrapMode: Text.WordWrap
    }
}
