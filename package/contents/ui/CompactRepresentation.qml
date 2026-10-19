import QtQuick
import QtQuick.Layouts

Rectangle {
    id: dashboard
    color: "transparent"
    property color panelColor: Qt.rgba(0.07, 0.094, 0.125, root.panelOpacity / 100)
    property color panelBorderColor: Qt.rgba(0.31, 0.42, 0.49, Math.min(0.45, root.panelOpacity / 160))

    function fontSize(base) { return Math.round(base * root.fontScale / 100) }

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
            Text { visible: root.showBattery && root.batteryLevel >= 0; text: "BAT " + root.batteryLevel + "%  " + root.batteryPowerWatts.toFixed(1) + "W  " + root.batteryVoltage.toFixed(1) + "V  " + root.batteryStatus; color: root.batteryLevel < 20 ? "#f38ba8" : "#a6e3a1"; font.family: "monospace"; font.pixelSize: dashboard.fontSize(13); font.bold: true }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 224
            columns: root.layoutMode === 1 ? 1 : 2
            rowSpacing: root.panelSpacing
            columnSpacing: root.panelSpacing

            Rectangle {
                visible: root.showCpu
                Layout.row: root.panelRow("cpu")
                Layout.column: root.panelColumn("cpu")
                Layout.fillWidth: true
                Layout.preferredHeight: 108
                color: dashboard.panelColor
                border.color: dashboard.panelBorderColor
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
                    LineChart {
                        visible: root.chartStyle === 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        download: root.cpuHistory
                        downloadColor: "#89b4fa"
                    }
                    Row {
                        visible: root.chartStyle !== 0
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        Repeater {
                            model: root.cpuHistory
                            delegate: Rectangle {
                                width: root.chartStyle === 2 ? 6 : 10
                                height: Math.max(3, 48 * modelData / 100)
                                anchors.bottom: parent.bottom
                                color: modelData > 85 ? "#f38ba8" : "#89b4fa"
                            }
                        }
                    }
                }
            }

            Rectangle {
                visible: root.showMemory
                Layout.row: root.panelRow("memory")
                Layout.column: root.panelColumn("memory")
                Layout.fillWidth: true
                Layout.preferredHeight: 108
                color: dashboard.panelColor
                border.color: dashboard.panelBorderColor
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
                visible: root.showNetwork
                Layout.row: root.panelRow("network")
                Layout.column: root.panelColumn("network")
                Layout.columnSpan: root.layoutMode === 2 ? 2 : 1
                Layout.fillWidth: true; Layout.preferredHeight: 108
                color: dashboard.panelColor; border.color: dashboard.panelBorderColor; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "NETIO"; color: "#cba6f7"; font.family: "monospace"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: root.networkLabel + (root.networkLinkMbps > 0 ? "  " + root.networkLinkMbps.toFixed(0) + " Mb/s" : "") ; color: "#a7b3c2"; font.family: "monospace"; elide: Text.ElideRight }
                    }
                    LineChart { Layout.fillWidth: true; Layout.fillHeight: true; download: root.rxHistory; upload: root.txHistory; style: root.chartStyle }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "↓ " + root.formatRate(root.rxRate); color: "#89dceb"; font.family: "monospace" }
                        Item { Layout.fillWidth: true }
                        Text { text: "↑ " + root.formatRate(root.txRate); color: "#f5c2e7"; font.family: "monospace" }
                    }
                }
            }

            Rectangle {
                visible: root.showDisk
                Layout.row: root.panelRow("disk")
                Layout.column: root.panelColumn("disk")
                Layout.fillWidth: true; Layout.preferredHeight: 108
                color: dashboard.panelColor; border.color: dashboard.panelBorderColor; border.width: 1
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
            visible: root.showPrograms
            Layout.fillWidth: true
            Layout.preferredHeight: 112
            color: dashboard.panelColor
            border.color: dashboard.panelBorderColor
            border.width: 1
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 3
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "PROGRAMS"; color: "#f38ba8"; font.family: "monospace"; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Text { text: "PID          COMMAND             CPU      MEM"; color: "#a7b3c2"; font.family: "monospace"; font.pixelSize: dashboard.fontSize(10) }
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
