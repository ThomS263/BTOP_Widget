import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

Rectangle {
    id: dashboard
    color: "transparent"
    property color panelColor: Qt.rgba(0.07, 0.094, 0.125, root.panelOpacity / 100)
    property color panelBorderColor: Qt.rgba(0.31, 0.42, 0.49, Math.min(0.45, root.panelOpacity / 160))

    function fontSize(base) { return Math.round(base * root.fontScale / 100) }
    property color accentColor: root.colorScheme === 1 ? "#a6e3a1" : root.colorScheme === 2 ? "#f9e2af" : "#89b4fa"

    Layout.minimumWidth: 380
    Layout.preferredWidth: 460
    Layout.minimumHeight: root.layoutMode === 1 ? 700 : 450
    Layout.preferredHeight: root.layoutMode === 1 ? 720 : 500

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Text { visible: root.showBattery && root.batteryLevel >= 0; text: "BAT " + root.batteryLevel + "%  " + root.batteryPowerWatts.toFixed(1) + "W  " + root.batteryVoltage.toFixed(1) + "V  " + root.batteryStatus; color: root.batteryLevel < 20 ? "#f38ba8" : "#a6e3a1"; font.family: "monospace"; font.pixelSize: dashboard.fontSize(13); font.bold: true }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.minimumHeight: root.layoutMode === 1 ? 464 : 232
            Layout.preferredHeight: root.layoutMode === 1 ? 464 : 232
            columns: root.layoutMode === 1 ? 1 : 2
            rowSpacing: root.panelSpacing
            columnSpacing: root.panelSpacing

            Rectangle {
                visible: root.showCpu
                Layout.row: root.panelRow("cpu")
                Layout.column: root.panelColumn("cpu")
                Layout.fillWidth: true
                Layout.preferredHeight: 98
                color: dashboard.panelColor
                border.color: dashboard.panelBorderColor
                border.width: 1
                clip: true
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                Text { text: "CPU"; color: dashboard.accentColor; font.family: "monospace"; font.bold: true }
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
                        downloadColor: dashboard.accentColor
                        zoom: root.graphZoom
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
                                color: modelData > 85 ? "#f38ba8" : dashboard.accentColor
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
                Layout.preferredHeight: 98
                color: dashboard.panelColor
                border.color: dashboard.panelBorderColor
                border.width: 1
                clip: true
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
                Layout.fillWidth: true; Layout.preferredHeight: 112
                color: dashboard.panelColor; border.color: dashboard.panelBorderColor; border.width: 1; clip: true
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                    Text { text: "NETIO"; color: "#cba6f7"; font.family: "monospace"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: root.networkLabel + (root.networkLinkMbps > 0 ? "  " + root.networkLinkMbps.toFixed(0) + " Mb/s" : "") ; color: "#a7b3c2"; font.family: "monospace"; elide: Text.ElideRight }
                    }
                    LineChart { Layout.fillWidth: true; Layout.fillHeight: true; download: root.rxHistory; upload: root.txHistory; style: root.chartStyle; zoom: root.graphZoom }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "↓ " + root.formatRate(root.rxRate); color: "#89dceb"; font.family: "monospace" }
                        Item { Layout.fillWidth: true }
                        Text { text: "↑ " + root.formatRate(root.txRate); color: "#f5c2e7"; font.family: "monospace" }
                    }
                    Text { visible: root.showNetworkDetails; Layout.fillWidth: true; text: root.interfaceSummary(); color: "#a7b3c2"; font.family: "monospace"; font.pixelSize: dashboard.fontSize(10); elide: Text.ElideRight }
                }
            }

            Rectangle {
                visible: root.showDisk
                Layout.row: root.panelRow("disk")
                Layout.column: root.panelColumn("disk")
                Layout.fillWidth: true; Layout.preferredHeight: 98
                color: dashboard.panelColor; border.color: dashboard.panelBorderColor; border.width: 1; clip: true
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
                    Text { Layout.fillWidth: true; text: root.diskUsedGiB.toFixed(0) + " / " + root.diskTotalGiB.toFixed(0) + " GiB"; color: "#cdd6f4"; font.family: "monospace"; elide: Text.ElideRight }
                    Text { text: "load " + root.loadLabel + "   proc " + root.processLabel; color: "#f9e2af"; font.family: "monospace" }
                }
            }
        }

        Rectangle {
            visible: root.showHardware
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.minimumHeight: 96
            Layout.preferredHeight: 96
            color: dashboard.panelColor
            border.color: dashboard.panelBorderColor
            border.width: 1
            clip: true
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 10; spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "HARDWARE" + (root.temperatureWarningVisible() ? "  ⚠" : ""); color: root.temperatureWarningVisible() ? "#f38ba8" : dashboard.accentColor; font.family: "monospace"; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Text { text: root.connectionStatus + (root.pingMs >= 0 ? "  " + root.pingMs.toFixed(0) + " ms" : ""); color: root.connectionStatus === "online" ? "#a6e3a1" : "#f38ba8"; font.family: "monospace" }
                }
                Text {
                    Layout.fillWidth: true
                    text: "GPU " + (root.gpuTemperature >= 0 ? root.gpuTemperature.toFixed(0) + "°C" : "--") + "  " + (root.gpuUsage >= 0 ? root.gpuUsage + "%" : "--") + "  " + (root.gpuPowerWatts >= 0 ? root.gpuPowerWatts.toFixed(1) + "W" : "--") + "    CPU " + (root.cpuTemperature >= 0 ? root.cpuTemperature.toFixed(0) + "°C" : "--") + "    NVMe " + (root.nvmeTemperature >= 0 ? root.nvmeTemperature.toFixed(0) + "°C" : "--")
                    color: "#cdd6f4"; font.family: "monospace"; elide: Text.ElideRight
                }
                Text { text: root.fanLabel + "  profile " + root.platformProfile + (root.fanSpeedTarget > 0 ? "  T" + root.fanSpeedTarget + "%" : "  auto"); color: "#a7b3c2"; font.family: "monospace"; elide: Text.ElideRight }
                Text { text: "VRAM " + (root.vramUsedGiB >= 0 ? root.vramUsedGiB.toFixed(1) + " / " + root.vramTotalGiB.toFixed(1) + " GiB" : "--") + "    kernel " + root.kernelLabel; color: "#a7b3c2"; font.family: "monospace"; elide: Text.ElideRight }
            }
        }

        Rectangle {
            visible: root.showPrograms
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.minimumHeight: 122
            Layout.preferredHeight: 122
            color: dashboard.panelColor
            border.color: dashboard.panelBorderColor
            border.width: 1
            clip: true
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 3
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "PROGRAMS"; color: "#f38ba8"; font.family: "monospace"; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Controls.TextField { placeholderText: "filter"; text: root.processFilter; onTextChanged: root.processFilter = text; Layout.preferredWidth: 72; Layout.preferredHeight: 22 }
                }
                Column {
                    Layout.fillWidth: true
                    width: parent.width
                    height: 86
                    Repeater {
                        model: root.processes
                        delegate: Text {
                            visible: root.matchesProcess(modelData.name)
                            width: parent.width
                            height: 14
                            text: modelData.pid + "  " + modelData.name + "  " + modelData.cpu + "%  " + modelData.memory + "%"
                            color: "#cdd6f4"
                            font.family: "monospace"
                            font.pixelSize: dashboard.fontSize(10)
                            elide: Text.ElideRight
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                onClicked: root.openSystemMonitor()
                            }
                        }
                    }
                }
            }
        }

    }
}
