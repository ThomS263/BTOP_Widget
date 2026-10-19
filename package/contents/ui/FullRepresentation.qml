import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

ColumnLayout {
    id: full
    Layout.minimumWidth: Kirigami.Units.gridUnit * 16
    Layout.preferredWidth: Kirigami.Units.gridUnit * 20
    Layout.minimumHeight: Kirigami.Units.gridUnit * 8
    Layout.preferredHeight: Kirigami.Units.gridUnit * 10
    spacing: Kirigami.Units.gridUnit

    Kirigami.Heading {
        text: i18n("System monitor")
        level: 2
        Layout.alignment: Qt.AlignHCenter
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.margins: Kirigami.Units.gridUnit
        spacing: Kirigami.Units.gridUnit
        Metric { title: i18n("CPU"); value: root.cpuLabel; progress: root.cpuUsage / 100; Layout.fillWidth: true }
        Metric { title: i18n("Memory"); value: root.memoryLabel; progress: root.memoryUsage / 100; Layout.fillWidth: true }
        Metric { title: i18n("Load"); value: root.loadLabel; progress: Math.min(1, root.loadAverage / 4); Layout.fillWidth: true }
    }

    Controls.Label {
        text: i18n("%1 GiB of %2 GiB memory used", root.memoryUsedGiB.toFixed(1), root.memoryTotalGiB.toFixed(1))
        color: Kirigami.Theme.disabledTextColor
        Layout.alignment: Qt.AlignHCenter
    }

    Controls.Label {
        text: i18n("Network  ↓ %1   ↑ %2", root.formatRate(root.rxRate), root.formatRate(root.txRate))
        font.family: "monospace"
        Layout.alignment: Qt.AlignHCenter
    }

}
