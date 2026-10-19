import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    property string title
    property string value
    property real progress: 0
    spacing: Kirigami.Units.smallSpacing

    Kirigami.Heading {
        text: value
        level: 4
        Layout.fillWidth: true
        elide: Text.ElideRight
    }
    Kirigami.Heading {
        text: title
        level: 6
        color: Kirigami.Theme.disabledTextColor
        Layout.fillWidth: true
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 3
        radius: 2
        color: Kirigami.Theme.alternateBackgroundColor
        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, progress))
            height: parent.height
            radius: parent.radius
            color: Kirigami.Theme.highlightColor
        }
    }
}
