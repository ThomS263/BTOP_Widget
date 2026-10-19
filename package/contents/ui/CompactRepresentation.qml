import QtQuick
import QtQuick.Layouts

Rectangle {
    id: dashboard
    color: "transparent"

    Layout.minimumWidth: 540
    Layout.preferredWidth: 560
    Layout.minimumHeight: 400
    Layout.preferredHeight: 410

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 9

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Text { visible: root.batteryLevel >= 0; text: "BAT " + root.batteryLevel + "%  " + root.batteryPowerWatts.toFixed(1) + "W  " + root.batteryVoltage.toFixed(1) + "V"; color: root.batteryLevel < 20 ? "#f38ba8" : "#a6e3a1"; font.family: "monospace"; font.bold: true }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 224
            columns: 2
            rowSpacing: 8
            columnSpacing: 8

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 108
                color: "#30111820"
                border.color: "#70506a7d"
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                    Text { text: "CPU"; color: "#89b4fa"; font.family: "monospace"; font.bold: true }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: root.cpuLabel; color: "#f5f7ff"; font.family: "monospace"; font.pixelSize: 18; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: "usage"; color: "#a7b3c2"; font.family: "monospace" }
                    }
                    Row {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        Repeater {
                            model: root.cpuHistory
                            delegate: Rectangle {
                                width: 10; height: Math.max(3, 48 * modelData / 100); anchors.bottom: parent.bottom
                                color: modelData > 85 ? "#f38ba8" : "#89b4fa"
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 108
                color: "#30111820"
                border.color: "#70506a7d"
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                    Text { text: "MEMORY"; color: "#a6e3a1"; font.family: "monospace"; font.bold: true }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: root.memoryLabel; color: "#f5f7ff"; font.family: "monospace"; font.pixelSize: 18; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: "used"; color: "#a7b3c2"; font.family: "monospace" }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 9; color: "#60405466"
                        Rectangle { width: parent.width * root.memoryUsage / 100; height: parent.height; color: "#a6e3a1" }
                    }
                    Text { text: root.memoryUsedGiB.toFixed(1) + " / " + root.memoryTotalGiB.toFixed(1) + " GiB   swap " + Math.round(root.swapUsage) + "%"; color: "#cdd6f4"; font.family: "monospace" }
                }
            }

            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 108
                color: "#30111820"; border.color: "#70506a7d"; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "NETIO"; color: "#cba6f7"; font.family: "monospace"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: "RX / TX"; color: "#a7b3c2"; font.family: "monospace" }
                    }
                    LineChart { Layout.fillWidth: true; Layout.fillHeight: true; download: root.rxHistory; upload: root.txHistory }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "↓ " + root.formatRate(root.rxRate); color: "#89dceb"; font.family: "monospace" }
                        Item { Layout.fillWidth: true }
                        Text { text: "↑ " + root.formatRate(root.txRate); color: "#f5c2e7"; font.family: "monospace" }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 108
                color: "#30111820"; border.color: "#70506a7d"; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                    Text { text: "DISK • LOAD"; color: "#f9e2af"; font.family: "monospace"; font.bold: true }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "disk"; color: "#cdd6f4"; font.family: "monospace" }
                        Item { Layout.fillWidth: true }
                        Text { text: Math.round(root.diskUsage) + "%"; color: "#f9e2af"; font.family: "monospace"; font.bold: true }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 9; color: "#60405466"
                        Rectangle { width: parent.width * root.diskUsage / 100; height: parent.height; color: "#f9e2af" }
                    }
                    Text { text: root.diskUsedGiB.toFixed(0) + " / " + root.diskTotalGiB.toFixed(0) + " GiB"; color: "#cdd6f4"; font.family: "monospace" }
                    Text { text: "load " + root.loadLabel + "   proc " + root.processLabel; color: "#f9e2af"; font.family: "monospace" }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 112
            color: "#30111820"
            border.color: "#70506a7d"
            border.width: 1
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 3
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "PROGRAMS"; color: "#f38ba8"; font.family: "monospace"; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Text { text: "PID          COMMAND             CPU      MEM"; color: "#a7b3c2"; font.family: "monospace"; font.pixelSize: 10 }
                }
                Column {
                    Layout.fillWidth: true
                    Repeater {
                        model: root.processes
                        delegate: RowLayout {
                            width: parent.width
                            height: 16
                            Text { text: modelData.pid; color: "#a7b3c2"; font.family: "monospace"; width: 55 }
                            Text { text: modelData.name; color: "#cdd6f4"; font.family: "monospace"; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: modelData.cpu + "%"; color: "#89b4fa"; font.family: "monospace"; width: 55; horizontalAlignment: Text.AlignRight }
                            Text { text: modelData.memory + "%"; color: "#a6e3a1"; font.family: "monospace"; width: 55; horizontalAlignment: Text.AlignRight }
                        }
                    }
                }
            }
        }

    }
}
