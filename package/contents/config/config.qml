/* SPDX-License-Identifier: Apache-2.0 */
import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Display")
        icon: "preferences-desktop-theme"
        source: "configDisplay.qml"
    }
    ConfigCategory {
        name: i18n("Data")
        icon: "computer"
        source: "configData.qml"
    }
}
