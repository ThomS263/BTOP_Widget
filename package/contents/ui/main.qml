import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    property real cpuUsage: 0
    property real memoryUsage: 0
    property real memoryUsedGiB: 0
    property real memoryTotalGiB: 0
    property real swapUsage: 0
    property real diskUsage: 0
    property real diskUsedGiB: 0
    property real diskTotalGiB: 0
    property real batteryPowerWatts: 0
    property real batteryVoltage: 0
    property int batteryLevel: -1
    property real loadAverage: 0
    property real uptimeSeconds: 0
    property real rxRate: 0
    property real txRate: 0
    property real previousRx: 0
    property real previousTx: 0
    property double previousNetworkTime: 0
    property string cpuLabel: "--"
    property string memoryLabel: "--"
    property string loadLabel: "--"
    property string uptimeLabel: "--"
    property string processLabel: "--"
    property var previousCpu: null
    property var cpuHistory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var rxHistory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var txHistory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var processes: []

    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: compactRepresentation
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    function parseStats(output) {
        const lines = output.trim().split("\n")
        if (lines.length < 7) return

        const cpu = lines[0].trim().split(";").map(Number)
        const idle = cpu[3] + (cpu[4] || 0)
        const total = cpu.reduce((a, b) => a + b, 0)
        if (previousCpu) {
            const totalDelta = total - previousCpu.total
            const idleDelta = idle - previousCpu.idle
            cpuUsage = totalDelta > 0 ? Math.max(0, Math.min(100, 100 * (1 - idleDelta / totalDelta))) : 0
            cpuHistory = cpuHistory.slice(1).concat([cpuUsage])
        }
        previousCpu = { total: total, idle: idle }

        const mem = {}
        lines[1].split(";").forEach(function(part) {
            const fields = part.trim().split(/\s+/)
            if (fields.length >= 2) mem[fields[0]] = Number(fields[1])
        })
        memoryTotalGiB = (mem.MemTotal || 0) / 1048576
        memoryUsedGiB = ((mem.MemTotal || 0) - (mem.MemAvailable || 0)) / 1048576
        memoryUsage = memoryTotalGiB > 0 ? memoryUsedGiB / memoryTotalGiB * 100 : 0
        const swapTotal = Number(mem.SwapTotal) || 0
        const swapFree = Number(mem.SwapFree) || 0
        swapUsage = swapTotal > 0 ? (swapTotal - swapFree) / swapTotal * 100 : 0
        const network = lines[2].trim().split(";").map(Number)
        const now = Date.now()
        const seconds = previousNetworkTime > 0 ? Math.max(0.25, (now - previousNetworkTime) / 1000) : 1
        if (previousNetworkTime > 0) {
            rxRate = Math.max(0, (network[0] - previousRx) / seconds)
            txRate = Math.max(0, (network[1] - previousTx) / seconds)
            rxHistory = rxHistory.slice(1).concat([rxRate])
            txHistory = txHistory.slice(1).concat([txRate])
        }
        previousRx = network[0] || 0
        previousTx = network[1] || 0
        previousNetworkTime = now
        const loadParts = lines[3].trim().split(";")
        loadAverage = Number(loadParts[0]) || 0
        processLabel = loadParts[1] || "--"
        uptimeSeconds = Number(lines[4].trim()) || 0
        const disk = lines[5].trim().split(";").map(Number)
        diskUsedGiB = (disk[0] || 0) / 1048576
        diskTotalGiB = (disk[1] || 0) / 1048576
        diskUsage = diskTotalGiB > 0 ? diskUsedGiB / diskTotalGiB * 100 : 0
        const battery = lines[6].trim().split(";")
        batteryLevel = battery[0] === "NA" ? -1 : Number(battery[0])
        batteryPowerWatts = (Number(battery[2]) || 0) / 1000000
        batteryVoltage = (Number(battery[3]) || 0) / 1000000
        const processRows = []
        for (let i = 7; i < lines.length; i++) {
            const fields = lines[i].trim().split(/\s+/)
            if (fields.length >= 4) processRows.push({ pid: fields[0], name: fields[1], cpu: fields[2], memory: fields[3] })
        }
        processes = processRows
        cpuLabel = Math.round(cpuUsage) + "%"
        memoryLabel = Math.round(memoryUsage) + "%"
        loadLabel = loadAverage.toFixed(2)
        uptimeLabel = formatUptime(uptimeSeconds)
    }

    function refresh() {
        stats.run("sh " + Qt.resolvedUrl("tools/system-stats").toString().substring(7))
    }

    function formatRate(bytesPerSecond) {
        if (bytesPerSecond < 1024) return Math.round(bytesPerSecond) + " B/s"
        if (bytesPerSecond < 1048576) return (bytesPerSecond / 1024).toFixed(1) + " KiB/s"
        return (bytesPerSecond / 1048576).toFixed(1) + " MiB/s"
    }

    function formatUptime(seconds) {
        const days = Math.floor(seconds / 86400)
        const hours = Math.floor((seconds % 86400) / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        if (days > 0) return days + "d " + hours + "h"
        return hours + "h " + minutes + "m"
    }

    CommandRunner {
        id: stats
        onFinished: function(command, exitCode, stdout, stderr) {
            if (exitCode === 0) root.parseStats(stdout)
        }
    }

    Timer {
        interval: Math.max(250, Plasmoid.configuration.updateInterval)
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

}
