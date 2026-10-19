import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    property alias cfg_updateInterval: updateInterval.value
    property alias cfg_showBattery: showBattery.checked
    property alias cfg_showCpu: showCpu.checked
    property alias cfg_showMemory: showMemory.checked
    property alias cfg_showNetwork: showNetwork.checked
    property alias cfg_showDisk: showDisk.checked
    property alias cfg_showPrograms: showPrograms.checked
    property alias cfg_layoutMode: layoutMode.currentIndex
    property alias cfg_chartStyle: chartStyle.currentIndex

    Controls.SpinBox {
        id: updateInterval
        Kirigami.FormData.label: i18n("Update interval:")
        from: 250
        to: 10000
        stepSize: 250
        editable: true
        textFromValue: function(value) { return i18n("%1 ms", value); }
        valueFromText: function(text, locale) { return Number.fromLocaleString(locale, text.replace(/[^0-9]/g, "")); }
    }

    Controls.Label {
        Kirigami.FormData.label: ""
        text: i18n("The dashboard stays visible and updates continuously.")
        color: Kirigami.Theme.disabledTextColor
        wrapMode: Text.WordWrap
    }

    Controls.CheckBox {
        id: showBattery
        Kirigami.FormData.label: i18n("Show:")
        text: i18n("Battery, watts and voltage")
    }

    Controls.CheckBox { id: showCpu; text: i18n("CPU"); Kirigami.FormData.label: "" }
    Controls.CheckBox { id: showMemory; text: i18n("Memory and swap"); Kirigami.FormData.label: "" }
    Controls.CheckBox { id: showNetwork; text: i18n("Network"); Kirigami.FormData.label: "" }
    Controls.CheckBox { id: showDisk; text: i18n("Disk and load"); Kirigami.FormData.label: "" }
    Controls.CheckBox { id: showPrograms; text: i18n("Top programs"); Kirigami.FormData.label: "" }

    Controls.ComboBox {
        id: layoutMode
        Kirigami.FormData.label: i18n("Panel layout:")
        model: [i18n("Shell grid (2 x 2)"), i18n("Single column"), i18n("Wide network panel")]
    }

    Controls.ComboBox {
        id: chartStyle
        Kirigami.FormData.label: i18n("Graph style:")
        model: [i18n("Lines"), i18n("Bars"), i18n("Blocks / steps")]
    }
}
