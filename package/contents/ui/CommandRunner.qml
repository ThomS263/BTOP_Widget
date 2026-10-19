import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    id: commandRunner

    signal finished(string command, int exitCode, string stdout, string stderr)

    function run(command) {
        dataSource.connectSource(command)
    }

    Plasma5Support.DataSource {
        id: dataSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            commandRunner.finished(source, data["exit code"], data.stdout || "", data.stderr || "")
            disconnectSource(source)
        }
    }
}
