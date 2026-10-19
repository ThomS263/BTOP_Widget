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
    property alias cfg_panelOrder: panelOrder.currentIndex
    property alias cfg_historyLength: historyLength.currentIndex
    property alias cfg_networkInterface: networkInterface.text
    property alias cfg_processCount: processCount.value
    property alias cfg_processSort: processSort.currentIndex
    property alias cfg_panelOpacity: panelOpacity.value
    property alias cfg_fontScale: fontScale.value
    property alias cfg_panelSpacing: panelSpacing.value
    property alias cfg_profile: profile.currentIndex
    property alias cfg_colorScheme: colorScheme.currentIndex
    property alias cfg_showHardware: showHardware.checked
    property alias cfg_showDisks: showDisks.checked

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
    Controls.CheckBox { id: showHardware; text: i18n("GPU, temperatures and fans"); Kirigami.FormData.label: "" }
    Controls.CheckBox { id: showDisks; text: i18n("Additional disks"); Kirigami.FormData.label: "" }

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

    Controls.ComboBox {
        id: profile
        Kirigami.FormData.label: i18n("Profile:")
        model: [i18n("Custom"), i18n("Minimal"), i18n("Hardware")]
    }

    Controls.ComboBox {
        id: colorScheme
        Kirigami.FormData.label: i18n("Color scheme:")
        model: [i18n("KDE / blue"), i18n("btop / green"), i18n("Amber")]
    }

    Controls.ComboBox {
        id: panelOrder
        Kirigami.FormData.label: i18n("Panel order:")
        model: [i18n("CPU, memory, network, disk"), i18n("Network first"), i18n("Memory first"), i18n("Disk first")]
    }

    Controls.ComboBox {
        id: historyLength
        Kirigami.FormData.label: i18n("Graph history:")
        model: [i18n("20 samples"), i18n("40 samples"), i18n("80 samples")]
    }

    Controls.TextField {
        id: networkInterface
        Kirigami.FormData.label: i18n("Network interface:")
        placeholderText: i18n("Auto / all interfaces")
    }

    Controls.SpinBox {
        id: processCount
        Kirigami.FormData.label: i18n("Processes shown:")
        from: 3
        to: 10
        editable: true
    }

    Controls.ComboBox {
        id: processSort
        Kirigami.FormData.label: i18n("Sort processes by:")
        model: [i18n("CPU"), i18n("Memory"), i18n("Name")]
    }

    Controls.SpinBox {
        id: panelOpacity
        Kirigami.FormData.label: i18n("Panel opacity:")
        from: 5
        to: 70
        editable: true
        textFromValue: function(value) { return i18n("%1%", value); }
    }

    Controls.SpinBox {
        id: fontScale
        Kirigami.FormData.label: i18n("Font scale:")
        from: 80
        to: 130
        stepSize: 5
        editable: true
        textFromValue: function(value) { return i18n("%1%", value); }
    }

    Controls.SpinBox {
        id: panelSpacing
        Kirigami.FormData.label: i18n("Panel spacing:")
        from: 2
        to: 20
        editable: true
        textFromValue: function(value) { return i18n("%1 px", value); }
    }
}
