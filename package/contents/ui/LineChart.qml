import QtQuick

Canvas {
    id: chart
    property var download: []
    property var upload: []
    property color downloadColor: "#89dceb"
    property color uploadColor: "#f5c2e7"
    property int style: 0

    onDownloadChanged: requestPaint()
    onUploadChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onStyleChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        ctx.lineWidth = 1
        ctx.strokeStyle = "#60405466"
        for (let x = 0; x <= width; x += Math.max(1, width / 8)) {
            ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, height); ctx.stroke()
        }
        for (let y = 0; y <= height; y += Math.max(1, height / 3)) {
            ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke()
        }

        const maxValue = Math.max(1, ...download, ...upload)
        drawSeries(ctx, download, downloadColor, maxValue)
        drawSeries(ctx, upload, uploadColor, maxValue)
    }

    function drawSeries(ctx, values, color, maxValue) {
        if (!values || values.length < 2) return
        if (style === 1) {
            const barWidth = Math.max(2, width / values.length * 0.7)
            ctx.fillStyle = color
            for (let i = 0; i < values.length; i++) {
                const barHeight = Math.max(1, (values[i] / maxValue) * (height - 4))
                ctx.fillRect(i * width / values.length, height - barHeight, barWidth, barHeight)
            }
            return
        }
        ctx.beginPath()
        for (let i = 0; i < values.length; i++) {
            const x = i * width / (values.length - 1)
            const y = height - (values[i] / maxValue) * (height - 4) - 2
            if (i === 0) {
                ctx.moveTo(x, y)
            } else if (style === 2) {
                const previousY = height - (values[i - 1] / maxValue) * (height - 4) - 2
                ctx.lineTo(x, previousY)
                ctx.lineTo(x, y)
            } else {
                ctx.lineTo(x, y)
            }
        }
        ctx.lineWidth = 2
        ctx.strokeStyle = color
        ctx.stroke()
    }
}
