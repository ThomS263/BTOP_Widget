import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root
    implicitWidth: 640
    implicitHeight: 560
    property alias cfg_layoutMode: layoutMode.currentIndex
    property alias cfg_panelOrder: panelOrder.currentIndex
    property alias cfg_chartStyle: chartStyle.currentIndex
    property alias cfg_graphZoom: graphZoom.currentIndex
    property alias cfg_colorScheme: colorScheme.currentIndex
    property alias cfg_panelOpacity: panelOpacity.value
    property alias cfg_fontScale: fontScale.value
    property alias cfg_panelSpacing: panelSpacing.value

    Controls.ScrollView {
        id: scrollView
        Kirigami.FormData.label: ""
        implicitHeight: root.implicitHeight
        clip: true
        contentWidth: availableWidth
        contentHeight: formLayout.implicitHeight

        Kirigami.FormLayout {
            id: formLayout
            width: scrollView.availableWidth
            implicitHeight: childrenRect.height + Kirigami.Units.largeSpacing

        Controls.ComboBox { id: layoutMode; Kirigami.FormData.label: i18n("Panel layout:"); model: [i18n("Shell grid (2 x 2)"), i18n("Single column"), i18n("Wide network panel")] }
        Controls.ComboBox { id: panelOrder; Kirigami.FormData.label: i18n("Panel order:"); model: [i18n("CPU, memory, network, disk"), i18n("Network first"), i18n("Memory first"), i18n("Disk first")] }
        Controls.ComboBox { id: chartStyle; Kirigami.FormData.label: i18n("Graph style:"); model: [i18n("Lines"), i18n("Bars"), i18n("Blocks / steps"), i18n("Dots")] }
        Controls.ComboBox { id: graphZoom; Kirigami.FormData.label: i18n("Graph zoom:"); model: [i18n("Fit all values"), i18n("2x"), i18n("4x")] }
        Controls.ComboBox { id: colorScheme; Kirigami.FormData.label: i18n("Color scheme:"); model: [i18n("KDE / blue"), i18n("btop / green"), i18n("Amber")] }

        Controls.SpinBox { id: panelOpacity; Kirigami.FormData.label: i18n("Panel opacity:"); from: 5; to: 70; editable: true; textFromValue: function(value) { return i18n("%1%", value); } }
        Controls.SpinBox { id: fontScale; Kirigami.FormData.label: i18n("Font scale:"); from: 80; to: 130; stepSize: 5; editable: true; textFromValue: function(value) { return i18n("%1%", value); } }
        Controls.SpinBox { id: panelSpacing; Kirigami.FormData.label: i18n("Panel spacing:"); from: 2; to: 20; editable: true; textFromValue: function(value) { return i18n("%1 px", value); } }
        }
    }
}
