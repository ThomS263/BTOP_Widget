import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

Rectangle {
    id: classic
    color: "transparent"
    property color panelColor: Qt.rgba(0.07, 0.094, 0.125, root.panelOpacity / 100)
    property color borderColor: Qt.rgba(0.45, 0.55, 0.68, 0.42)
    property color textColor: "#d9e2f2"
    property color mutedColor: "#9aa8bb"
    property color accentColor: root.colorScheme === 1 ? "#a6e3a1" : root.colorScheme === 2 ? "#f9e2af" : "#89b4fa"

    Layout.minimumWidth: root.representationMinimumWidth
    Layout.preferredWidth: root.representationPreferredWidth
    Layout.minimumHeight: root.representationMinimumHeight
    Layout.preferredHeight: root.representationPreferredHeight
    width: Layout.preferredWidth
    height: Layout.preferredHeight

    function size(value) { return Math.round(value * root.fontScale / 100) }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 7

        RowLayout {
            Layout.fillWidth: true
            Text { text: "BTOP"; color: classic.textColor; font.family: "monospace"; font.pixelSize: classic.size(25); font.bold: true }
            Item { Layout.fillWidth: true }
            Text { text: root.batteryLevel >= 0 ? "BAT " + root.batteryLevel + (root.batteryEtaLabel !== "" ? "%  " + root.batteryEtaLabel : "%") : "BAT --"; color: root.batteryLevel < 20 ? "#f38ba8" : classic.accentColor; font.family: "monospace"; font.bold: true }
        }

        Text { text: "classic widget  •  live"; color: classic.mutedColor; font.family: "monospace"; font.pixelSize: classic.size(10) }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 7
            columnSpacing: 7

            Rectangle {
                visible: root.showCpu
                Layout.fillWidth: true; Layout.preferredHeight: 100
                color: classic.panelColor; border.color: classic.borderColor; border.width: 1; radius: 4
                ColumnLayout { anchors.fill: parent; anchors.margins: 10; spacing: 4
                    Text { text: "CPU"; color: classic.accentColor; font.family: "monospace"; font.bold: true }
                    Text { text: root.cpuLabel; color: classic.textColor; font.family: "monospace"; font.pixelSize: classic.size(20); font.bold: true }
                    Rectangle { Layout.fillWidth: true; height: 7; color: "#344052"; Rectangle { width: parent.width * root.cpuUsage / 100; height: parent.height; color: classic.accentColor } }
                }
            }

            Rectangle {
                visible: root.showMemory
                Layout.fillWidth: true; Layout.preferredHeight: 100
                color: classic.panelColor; border.color: classic.borderColor; border.width: 1; radius: 4
                ColumnLayout { anchors.fill: parent; anchors.margins: 10; spacing: 4
                    Text { text: "MEM"; color: "#a6e3a1"; font.family: "monospace"; font.bold: true }
                    Text { text: root.memoryLabel; color: classic.textColor; font.family: "monospace"; font.pixelSize: classic.size(20); font.bold: true }
                    Rectangle { Layout.fillWidth: true; height: 7; color: "#344052"; Rectangle { width: parent.width * root.memoryUsage / 100; height: parent.height; color: "#a6e3a1" } }
                }
            }

            Rectangle {
                visible: root.showNetwork
                Layout.columnSpan: 2; Layout.fillWidth: true; Layout.preferredHeight: 94
                color: classic.panelColor; border.color: classic.borderColor; border.width: 1; radius: 4
                ColumnLayout { anchors.fill: parent; anchors.margins: 10; spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "NET"; color: "#cba6f7"; font.family: "monospace"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: root.networkLabel; color: classic.mutedColor; font.family: "monospace"; elide: Text.ElideRight }
                    }
                    Text { Layout.fillWidth: true; text: "↓ " + root.formatRate(root.rxRate) + "     ↑ " + root.formatRate(root.txRate); color: classic.textColor; font.family: "monospace"; elide: Text.ElideRight }
                    Text { visible: root.showNetworkDetails; Layout.fillWidth: true; text: root.interfaceSummary(); color: classic.mutedColor; font.family: "monospace"; font.pixelSize: classic.size(10); elide: Text.ElideRight }
                }
            }

            Rectangle {
                visible: root.showDisk
                Layout.columnSpan: 2; Layout.fillWidth: true; Layout.preferredHeight: root.showDisks ? 132 : 116
                color: classic.panelColor; border.color: classic.borderColor; border.width: 1; radius: 4
                ColumnLayout { anchors.fill: parent; anchors.margins: 10; spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "STORAGE"; color: "#f9e2af"; font.family: "monospace"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: Math.round(root.diskUsage) + "%"; color: "#f9e2af"; font.family: "monospace"; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 7; color: "#344052"; Rectangle { width: parent.width * root.diskUsage / 100; height: parent.height; color: "#f9e2af" } }
                    Text { Layout.fillWidth: true; text: root.diskUsedGiB.toFixed(0) + " / " + root.diskTotalGiB.toFixed(0) + " GiB"; color: classic.textColor; font.family: "monospace"; elide: Text.ElideRight; clip: true }
                    Text { Layout.fillWidth: true; text: "load " + root.loadLabel + "   proc " + root.processLabel; color: classic.mutedColor; font.family: "monospace"; elide: Text.ElideRight; clip: true }
                    Text { visible: root.showDisks; Layout.fillWidth: true; text: root.diskSummary(); color: classic.mutedColor; font.family: "monospace"; elide: Text.ElideRight; clip: true }
                }
            }
        }

        Rectangle {
            visible: root.showHardware
            Layout.fillWidth: true; Layout.preferredHeight: root.showFanSlider ? 106 : 72
            color: classic.panelColor; border.color: classic.borderColor; border.width: 1; radius: 4
            ColumnLayout { anchors.fill: parent; anchors.margins: 10; spacing: 3
                Text { Layout.fillWidth: true; text: "TEMP/FAN  " + root.fanLabel; color: classic.accentColor; font.family: "monospace"; elide: Text.ElideRight }
                Text { Layout.fillWidth: true; text: "GPU " + (root.gpuTemperature >= 0 ? root.gpuTemperature.toFixed(0) + "°C" : "--") + "   CPU " + (root.cpuTemperature >= 0 ? root.cpuTemperature.toFixed(0) + "°C" : "--") + "   " + root.platformProfile; color: classic.mutedColor; font.family: "monospace"; elide: Text.ElideRight }
                RowLayout {
                    visible: root.showFanSlider
                    Layout.fillWidth: true
                    Text { text: "TARGET"; color: classic.accentColor; font.family: "monospace" }
                    Controls.Slider { Layout.fillWidth: true; from: 0; to: 100; stepSize: 5; value: root.fanSpeedTarget; onMoved: root.setFanTarget(value) }
                    Text { text: root.fanSpeedTarget === 0 ? "AUTO" : root.fanSpeedTarget + "%"; color: classic.textColor; font.family: "monospace" }
                }
            }
        }

        Text { visible: root.showPrograms; Layout.fillWidth: true; text: "PROC  " + root.processLabel; color: "#f38ba8"; font.family: "monospace"; elide: Text.ElideRight }
    }
}
