import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Rectangle {
    id: dashboard
    color: "#111820"
    radius: Kirigami.Units.smallSpacing
    border.color: "#334452"
    border.width: 1

    Layout.minimumWidth: 240
    Layout.preferredWidth: 280
    Layout.minimumHeight: 130
    Layout.preferredHeight: 150

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true
            Kirigami.Icon {
                source: "utilities-system-monitor"
                color: "#8bd5ca"
                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                Layout.preferredHeight: Layout.preferredWidth
            }
            Text {
                text: "btop"
                color: "#8bd5ca"
                font.family: "monospace"
                font.bold: true
            }
            Item { Layout.fillWidth: true }
            Text { text: "LIVE"; color: "#a6e3a1"; font.family: "monospace" }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#334452" }

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.gridUnit
            ColumnLayout {
                Layout.fillWidth: true
                Text { text: "CPU  " + root.cpuLabel; color: "#cdd6f4"; font.family: "monospace"; font.bold: true }
                Row {
                    spacing: 1
                    Repeater {
                        model: root.cpuHistory
                        delegate: Rectangle {
                            width: 8
                            height: 22 * Math.max(0.08, modelData / 100)
                            anchors.bottom: parent.bottom
                            color: modelData > 85 ? "#f38ba8" : "#89b4fa"
                        }
                    }
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Text { text: "MEM  " + root.memoryLabel; color: "#cdd6f4"; font.family: "monospace"; font.bold: true }
                Rectangle {
                    Layout.fillWidth: true
                    height: 8
                    color: "#263746"
                    Rectangle { width: parent.width * root.memoryUsage / 100; height: parent.height; color: "#a6e3a1" }
                }
                Text { text: root.memoryUsedGiB.toFixed(1) + " / " + root.memoryTotalGiB.toFixed(1) + " GiB"; color: "#7f8c9c"; font.family: "monospace" }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Text { text: "NET"; color: "#cba6f7"; font.family: "monospace"; font.bold: true }
            Text { text: "▼ " + formatRate(root.rxRate); color: "#89dceb"; font.family: "monospace"; Layout.fillWidth: true }
            Text { text: "▲ " + formatRate(root.txRate); color: "#f5c2e7"; font.family: "monospace" }
        }

        Text {
            text: "LOAD  " + root.loadLabel
            color: "#f9e2af"
            font.family: "monospace"
            font.bold: true
        }
    }

}
