# btop Monitor Plasma Widget

A transparent KDE Plasma 6 widget that continuously displays a btop-style dashboard with live CPU, memory, network, disk, battery, and process information.

## Install

Requirements: KDE Plasma 6, CMake, Extra CMake Modules, and the Plasma development package.

```sh
./install.sh
```

Add **btop Monitor** from the Plasma widget chooser. Right-click the widget and open **Configure btop Monitor** to choose which panels are shown, select the panel layout, set the update interval, and switch the graph style between lines, bars, and blocks/steps.

The widget is a passive dashboard rather than a launcher or button. It reads local `/proc` data and uses standard system commands for the process list. No background service is required.

## KDE Store package

The `btop-plasma-widget-v1.1.0.plasmoid` archive is generated from the `package/` directory and can be uploaded to the KDE Store under **Plasma Widgets**.
