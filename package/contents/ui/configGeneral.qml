import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    property alias cfg_updateInterval: updateInterval.value

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
}
