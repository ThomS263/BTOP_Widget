# btop Monitor Plasma Widget

A transparent KDE Plasma 6 widget that continuously displays a btop-style dashboard with live CPU, memory, network, disk, battery, and process information.

## Install

Requirements: KDE Plasma 6, CMake, Extra CMake Modules, and the Plasma development package.

```sh
./install.sh
```

Add **btop Monitor** from the Plasma widget chooser. Right-click the widget and open **Configure btop Monitor** to choose which panels are shown, select the panel layout, set the update interval, and switch the graph style between lines, bars, and blocks/steps.

The widget is a passive dashboard rather than a launcher or button. It reads local `/proc` data and uses standard system commands for the process list. No background service is required.

## License

The project is licensed under the Apache License 2.0. See [LICENSE](LICENSE).

## Configuration

The configuration dialog controls panel visibility, panel layout/order, update interval, graph style and history length, network interface, process count/sorting, panel opacity, font scale, spacing, profiles, and color schemes. Hardware sensors, GPU/VRAM, temperatures, fans, connection status, multiple interfaces, and mounted filesystems are detected when available.

The widget exposes a 0–100% fan target hint. It is monitoring-only on systems
without a supported writable PWM interface; this project never writes unknown
hardware-control files. The current platform profile and available fan RPM
readings remain visible in the hardware panel.

## Visual UI matrix

Run `./tools/visual-ui-matrix.sh` from a Plasma session to exercise the
dashboard layouts, graph styles, color schemes, profiles, panel visibility,
ordering, zoom, history, and dense settings. It restarts Plasma for each
case, stores full-screen samples in `screenshots/`, and restores the original
applet configuration when it finishes.

## KDE Store package

The `btop-plasma-widget-v1.4.0.plasmoid` archive is generated from the
`package/` directory and can be uploaded to the KDE Store under **Plasma 6
Monitoring**. Build it with:

```sh
cmake -B build-store -S . -DPACKAGE_PLASMOID=ON
cmake --build build-store
```
