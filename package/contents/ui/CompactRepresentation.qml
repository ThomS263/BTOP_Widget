import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Rectangle {
    id: dashboard
    color: "transparent"
    radius: 4
    border.color: "#70405466"
    border.width: 1

    Layout.minimumWidth: 430
    Layout.preferredWidth: 460
    Layout.minimumHeight: 285
    Layout.preferredHeight: 295

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "btop"
                color: "#89dceb"
                font.family: "monospace"
                font.pixelSize: 18
                font.bold: true
            }
            Text {
                text: " // SYSTEM MONITOR"
                color: "#7f8c9c"
                font.family: "monospace"
                font.pixelSize: 13
            }
            Item { Layout.fillWidth: true }
            Text { text: "● LIVE"; color: "#a6e3a1"; font.family: "monospace"; font.bold: true }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#70405466" }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 68
            spacing: 18

            ColumnLayout {
                Layout.fillWidth: true
                Text { text: "[ CPU ]"; color: "#89b4fa"; font.family: "monospace"; font.bold: true }
                Text { text: root.cpuLabel + "  usage"; color: "#cdd6f4"; font.family: "monospace"; font.pixelSize: 15 }
                Row {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    spacing: 2
                    Repeater {
                        model: root.cpuHistory
                        delegate: Rectangle {
                            width: 9
                            height: Math.max(4, 46 * modelData / 100)
                            anchors.bottom: parent.bottom
                            color: modelData > 85 ? "#f38ba8" : "#89b4fa"
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Text { text: "[ MEMORY ]"; color: "#a6e3a1"; font.family: "monospace"; font.bold: true }
                Text { text: root.memoryLabel + "  used"; color: "#cdd6f4"; font.family: "monospace"; font.pixelSize: 15 }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 10
                    color: "#263746"
                    Rectangle { width: parent.width * root.memoryUsage / 100; height: parent.height; color: "#a6e3a1" }
                }
                Text { text: root.memoryUsedGiB.toFixed(1) + " / " + root.memoryTotalGiB.toFixed(1) + " GiB"; color: "#7f8c9c"; font.family: "monospace" }
                Text { text: "swap " + Math.round(root.swapUsage) + "%"; color: "#cba6f7"; font.family: "monospace" }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#60405466" }

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                Layout.fillWidth: true
                Text { text: "[ NETWORK ]"; color: "#cba6f7"; font.family: "monospace"; font.bold: true }
                Row {
                    Layout.fillWidth: true
                    height: 30
                    spacing: 1
                    Repeater {
                        model: root.rxHistory
                        delegate: Rectangle { width: 9; height: Math.max(3, Math.min(28, 8 + 22 * modelData / Math.max(1, root.rxRate, 1024))); anchors.bottom: parent.bottom; color: "#89dceb" }
                    }
                }
                Text { text: "↓ " + root.formatRate(root.rxRate) + "   ↑ " + root.formatRate(root.txRate); color: "#cdd6f4"; font.family: "monospace" }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Text { text: "[ DISK / LOAD ]"; color: "#f9e2af"; font.family: "monospace"; font.bold: true }
                Text { text: "disk " + Math.round(root.diskUsage) + "%  " + root.diskUsedGiB.toFixed(0) + "/" + root.diskTotalGiB.toFixed(0) + " GiB"; color: "#cdd6f4"; font.family: "monospace" }
                Text { text: "load " + root.loadLabel + "  proc " + root.processLabel; color: "#f9e2af"; font.family: "monospace" }
            }
        }

        Text {
            text: "uptime " + root.uptimeLabel + "   //   updates every " + Plasmoid.configuration.updateInterval + "ms"
            color: "#627789"
            font.family: "monospace"
            font.pixelSize: 11
        }
    }
}
