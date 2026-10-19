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
    property string batteryStatus: ""
    property real loadAverage: 0
    property real uptimeSeconds: 0
    property real rxRate: 0
    property real txRate: 0
    property real networkLinkMbps: 0
    property real previousRx: 0
    property real previousTx: 0
    property double previousNetworkTime: 0
    property string cpuLabel: "--"
    property string memoryLabel: "--"
    property string loadLabel: "--"
    property string uptimeLabel: "--"
    property string processLabel: "--"
    property string networkLabel: "--"
    property string connectionStatus: "--"
    property real pingMs: -1
    property real gpuTemperature: -1
    property real gpuPowerWatts: -1
    property real gpuUsage: -1
    property real vramUsedGiB: -1
    property real vramTotalGiB: -1
    property real cpuTemperature: -1
    property real nvmeTemperature: -1
    property real fanRpm: -1
    property string kernelLabel: "--"
    property var networkInterfaces: []
    property var disks: []
    property string processFilter: ""
    property var previousCpu: null
    property var cpuHistory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var rxHistory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var txHistory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var processes: []
    readonly property bool showBattery: Plasmoid.configuration.showBattery
    readonly property bool showCpu: Plasmoid.configuration.showCpu
    readonly property bool showMemory: Plasmoid.configuration.showMemory
    readonly property bool showNetwork: Plasmoid.configuration.showNetwork
    readonly property bool showDisk: Plasmoid.configuration.showDisk
    readonly property bool showPrograms: Plasmoid.configuration.showPrograms && profile !== 1
    readonly property int layoutMode: Plasmoid.configuration.layoutMode
    readonly property int chartStyle: Plasmoid.configuration.chartStyle
    readonly property int graphZoom: Plasmoid.configuration.graphZoom
    readonly property int panelOrder: Plasmoid.configuration.panelOrder
    readonly property int historySize: [20, 40, 80][Math.max(0, Math.min(2, Plasmoid.configuration.historyLength))]
    readonly property string selectedInterface: Plasmoid.configuration.networkInterface || ""
    readonly property int processCount: Plasmoid.configuration.processCount
    readonly property int processSort: Plasmoid.configuration.processSort
    readonly property int fanSpeedTarget: Plasmoid.configuration.fanSpeedTarget
    readonly property int panelOpacity: Plasmoid.configuration.panelOpacity
    readonly property int fontScale: Plasmoid.configuration.fontScale
    readonly property int panelSpacing: Plasmoid.configuration.panelSpacing
    readonly property int profile: Plasmoid.configuration.profile
    readonly property int colorScheme: Plasmoid.configuration.colorScheme
    readonly property bool showHardware: Plasmoid.configuration.showHardware && profile !== 1
    readonly property bool showDisks: Plasmoid.configuration.showDisks || profile === 2

    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: compactRepresentation
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    function panelRow(panel) {
        if (layoutMode === 2) return panel === "network" ? 0 : panel === "cpu" ? 1 : panel === "memory" ? 2 : 3
        if (layoutMode === 1) return panel === "cpu" ? 0 : panel === "memory" ? 1 : panel === "network" ? 2 : 3
        const order = panelOrder === 1 ? ["network", "cpu", "memory", "disk"] : panelOrder === 2 ? ["memory", "cpu", "disk", "network"] : panelOrder === 3 ? ["disk", "network", "cpu", "memory"] : ["cpu", "memory", "network", "disk"]
        return order.indexOf(panel) < 2 ? 0 : 1
    }

    function panelColumn(panel) {
        if (layoutMode === 1 || layoutMode === 2) return 0
        const order = panelOrder === 1 ? ["network", "cpu", "memory", "disk"] : panelOrder === 2 ? ["memory", "cpu", "disk", "network"] : panelOrder === 3 ? ["disk", "network", "cpu", "memory"] : ["cpu", "memory", "network", "disk"]
        return order.indexOf(panel) % 2
    }

    function appendHistory(history, value) {
        let next = history.concat([value])
        while (next.length > historySize) next.shift()
        while (next.length < historySize) next.unshift(0)
        return next
    }

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
            cpuHistory = appendHistory(cpuHistory, cpuUsage)
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
        const networkFields = lines[2].trim().split(";")
        const network = [Number(networkFields[0]) || 0, Number(networkFields[1]) || 0]
        networkLabel = networkFields[2] || "all"
        networkLinkMbps = Number(networkFields[3]) || 0
        const now = Date.now()
        const seconds = previousNetworkTime > 0 ? Math.max(0.25, (now - previousNetworkTime) / 1000) : 1
        if (previousNetworkTime > 0) {
            rxRate = Math.max(0, (network[0] - previousRx) / seconds)
            txRate = Math.max(0, (network[1] - previousTx) / seconds)
            rxHistory = appendHistory(rxHistory, rxRate)
            txHistory = appendHistory(txHistory, txRate)
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
        batteryPowerWatts = (Number(battery[1]) || 0) / 1000000
        batteryVoltage = (Number(battery[2]) || 0) / 1000000
        batteryStatus = battery[3] || ""
        const parsedNetworks = []
        const parsedDisks = []
        for (let i = 7; i < lines.length; i++) {
            const parts = lines[i].trim().split(";")
            if (parts[0] === "GPU") {
                gpuTemperature = Number(parts[1]) || -1
                gpuPowerWatts = Number(parts[2]) || -1
                gpuUsage = Number(parts[3]) || -1
                vramUsedGiB = Number(parts[4]) > 0 ? Number(parts[4]) / 1073741824 : -1
                vramTotalGiB = Number(parts[5]) > 0 ? Number(parts[5]) / 1073741824 : -1
            } else if (parts[0] === "SENSORS") {
                cpuTemperature = Number(parts[1]) || -1
                nvmeTemperature = Number(parts[2]) || -1
                fanRpm = Number(parts[3]) || -1
            } else if (parts[0] === "NET" && parts.length >= 6) {
                parsedNetworks.push({ name: parts[1], rx: Number(parts[2]) || 0, tx: Number(parts[3]) || 0, speed: Number(parts[4]) || 0, state: parts[5] })
            } else if (parts[0] === "DISK" && parts.length >= 5) {
                parsedDisks.push({ mount: parts[1], used: Number(parts[2]) / 1048576, total: Number(parts[3]) / 1048576, percent: Number(String(parts[4]).replace("%", "")) || 0 })
            } else if (parts[0] === "KERNEL") {
                kernelLabel = parts[1] || "--"
            }
        }
        networkInterfaces = parsedNetworks
        disks = parsedDisks
        const processMarker = lines.indexOf("PROC")
        if (processMarker >= 0 && processMarker + 1 < lines.length) {
            const processRows = []
            for (let i = processMarker + 1; i < lines.length; i++) {
                const fields = lines[i].trim().split(/\s+/)
                if (fields.length >= 4) processRows.push({ pid: fields[0], name: fields[1], cpu: fields[2], memory: fields[3] })
            }
            processes = processRows
        }
        cpuLabel = Math.round(cpuUsage) + "%"
        memoryLabel = Math.round(memoryUsage) + "%"
        loadLabel = loadAverage.toFixed(2)
        uptimeLabel = formatUptime(uptimeSeconds)
    }

    function refresh() {
        const script = Qt.resolvedUrl("tools/system-stats").toString().substring(7)
        const interfaceArg = selectedInterface.replace(/[^A-Za-z0-9_.:-]/g, "")
        const sortArg = processSort === 1 ? "memory" : processSort === 2 ? "name" : "cpu"
        stats.run("sh '" + script + "' --interface '" + interfaceArg + "' --count " + processCount + " --sort " + sortArg)
    }

    function refreshProcesses() {
        const sortArg = processSort === 1 ? "-%mem" : processSort === 2 ? "comm" : "-%cpu"
        processStats.run("ps -eo pid=,comm=,%cpu=,%mem= --sort=" + sortArg + " | head -n " + processCount)
    }

    function parseProcesses(output) {
        const processRows = []
        output.trim().split("\n").forEach(function(line) {
            const fields = line.trim().split(/\s+/)
            if (fields.length >= 4) processRows.push({ pid: fields[0], name: fields[1], cpu: fields[2], memory: fields[3] })
        })
        processes = processRows
    }

    function matchesProcess(name) {
        return processFilter.trim() === "" || name.toLowerCase().indexOf(processFilter.trim().toLowerCase()) >= 0
    }

    function diskSummary() {
        return disks.slice(0, 3).map(function(disk) { return disk.mount + " " + Math.round(disk.percent) + "%" }).join("   ")
    }

    function interfaceSummary() {
        return networkInterfaces.map(function(item) { return item.name + ":" + item.state }).join("  ")
    }

    function processSummary() {
        return processes.filter(function(item) { return matchesProcess(item.name) }).map(function(item) {
            return item.pid + "  " + item.name + "  " + item.cpu + "%  " + item.memory + "%"
        }).join("\n")
    }

    function terminateProcess(pid) {
        if (/^[0-9]+$/.test(String(pid))) processAction.run("kill -TERM " + pid)
    }

    function openSystemMonitor() {
        processAction.run("plasma-systemmonitor")
    }

    function refreshPing() {
        pingRunner.run("ping -c 1 -W 1 1.1.1.1")
    }

    function parsePing(output) {
        const match = output.match(/time[=<]([0-9.]+)/)
        pingMs = match ? Number(match[1]) : -1
        connectionStatus = pingMs >= 0 ? "online" : "offline"
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

    CommandRunner {
        id: processStats
        onFinished: function(command, exitCode, stdout, stderr) {
            if (exitCode === 0) root.parseProcesses(stdout)
        }
    }

    CommandRunner {
        id: pingRunner
        onFinished: function(command, exitCode, stdout, stderr) {
            root.parsePing(exitCode === 0 ? stdout : "")
        }
    }

    CommandRunner { id: processAction }

    Timer {
        interval: Math.max(250, Plasmoid.configuration.updateInterval)
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refreshProcesses()
    }

    Timer {
        interval: 10000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refreshPing()
    }

}
