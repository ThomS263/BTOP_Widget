# btop Monitor Plasma Widget

A small KDE Plasma 6 widget that continuously displays a btop-style dashboard with live CPU, memory, and load values.

## Install

Requirements: Plasma 6, `btop`, CMake, Extra CMake Modules, and the Plasma development package.

```sh
./install.sh
```

Add **btop Monitor** from the Plasma widget chooser. The default launcher is `konsole --hold -e btop`; change it in the widget settings for another terminal, such as `kitty btop`.

The widget is a passive dashboard rather than a launcher or button. It reads `/proc/stat`, `/proc/meminfo`, and `/proc/loadavg` locally. No background service is required.
