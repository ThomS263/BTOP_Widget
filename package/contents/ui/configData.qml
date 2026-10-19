import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    property alias cfg_historyLength: historyLength.currentIndex
    property alias cfg_networkInterface: networkInterface.text
    property alias cfg_processCount: processCount.value
    property alias cfg_processSort: processSort.currentIndex

    Controls.ComboBox { id: historyLength; Kirigami.FormData.label: i18n("Graph history:"); model: [i18n("20 samples"), i18n("40 samples"), i18n("80 samples")] }
    Controls.TextField { id: networkInterface; Kirigami.FormData.label: i18n("Network interface:"); placeholderText: i18n("Auto / all interfaces"); selectByMouse: true }
    Controls.SpinBox { id: processCount; Kirigami.FormData.label: i18n("Processes shown:"); from: 3; to: 10; editable: true }
    Controls.ComboBox { id: processSort; Kirigami.FormData.label: i18n("Sort processes by:"); model: [i18n("CPU"), i18n("Memory"), i18n("Name")] }

    Controls.Label {
        Kirigami.FormData.label: ""
        text: i18n("Leave the interface empty to combine all active network interfaces.")
        color: Kirigami.Theme.disabledTextColor
        wrapMode: Text.WordWrap
    }
}
