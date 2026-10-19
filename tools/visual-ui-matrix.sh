#!/usr/bin/env bash
set -euo pipefail

# Visual smoke matrix for the Plasma widget. It covers each enum value and
# representative visibility/profile combinations without changing the user's
# final configuration: the Plasma applet config is restored on exit.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/plasma-org.kde.plasma.desktop-appletsrc"
SCREENSHOT_DIR="${ROOT_DIR}/screenshots"
BACKUP_DIR="$(mktemp -d /tmp/btop-widget-ui-check.XXXXXX)"
BACKUP_FILE="${BACKUP_DIR}/appletsrc"
PLASMA_LOG="${BACKUP_DIR}/plasmashell.log"

mkdir -p "$SCREENSHOT_DIR"
cp "$CONFIG_FILE" "$BACKUP_FILE"

restore() {
    cp "$BACKUP_FILE" "$CONFIG_FILE"
    pkill -TERM -x plasmashell 2>/dev/null || true
    sleep 2
    setsid -f plasmashell --replace >"$PLASMA_LOG" 2>&1
    sleep 8
    printf 'Restored original Plasma configuration.\n'
}
trap restore EXIT INT TERM

set_value() {
    kwriteconfig6 --file "$CONFIG_FILE" \
        --group Containments --group 85 --group Applets --group 125 \
        --group Configuration --group General --key "$1" "$2"
}

defaults() {
    set_value layoutMode 0
    set_value chartStyle 0
    set_value colorScheme 0
    set_value profile 0
    set_value panelOrder 0
    set_value graphZoom 0
    set_value historyLength 0
    set_value processCount 5
    set_value processSort 0
    set_value panelSpacing 8
    set_value panelOpacity 19
    set_value fontScale 100
    set_value showBattery true
    set_value showCpu true
    set_value showMemory true
    set_value showNetwork true
    set_value showDisk true
    set_value showPrograms true
    set_value showHardware true
    set_value showDisks true
    set_value fanSpeedTarget 0
}

restart_plasma() {
    pkill -TERM -x plasmashell 2>/dev/null || true
    sleep 2
    setsid -f plasmashell --replace >"$PLASMA_LOG" 2>&1
    sleep 8
}

capture() {
    local name="$1"
    local was_desktop
    was_desktop="$(qdbus6 org.kde.KWin /KWin org.kde.KWin.showingDesktop 2>/dev/null || printf 'false')"
    if [[ "$was_desktop" != "true" ]]; then
        for _ in {1..3}; do
            qdbus6 org.kde.kglobalaccel /component/kwin \
                org.kde.kglobalaccel.Component.invokeShortcut 'Show Desktop' >/dev/null 2>&1 || true
            sleep 1
            [[ "$(qdbus6 org.kde.KWin /KWin org.kde.KWin.showingDesktop 2>/dev/null || printf 'false')" == "true" ]] && break
        done
    fi
    sleep 1
    spectacle -b -n -o "${SCREENSHOT_DIR}/${name}.png" >/dev/null
    if [[ "$was_desktop" != "true" && "$(qdbus6 org.kde.KWin /KWin org.kde.KWin.showingDesktop 2>/dev/null || printf 'false')" == "true" ]]; then
        qdbus6 org.kde.kglobalaccel /component/kwin \
            org.kde.kglobalaccel.Component.invokeShortcut 'Show Desktop' >/dev/null 2>&1 || true
    fi
}

run_case() {
    local name="$1"
    shift
    defaults
    while (($#)); do
        set_value "$1" "$2"
        shift 2
    done
    restart_plasma
    capture "$name"
    printf 'Captured %s.png\n' "$name"
}

run_case 01-grid-lines-kde layoutMode 0 chartStyle 0 colorScheme 0
run_case 02-grid-bars-green layoutMode 0 chartStyle 1 colorScheme 1
run_case 03-grid-blocks-amber layoutMode 0 chartStyle 2 colorScheme 2
run_case 04-single-lines layoutMode 1 chartStyle 0
run_case 05-wide-network layoutMode 2 chartStyle 1
run_case 06-network-first panelOrder 1
run_case 07-memory-first panelOrder 2
run_case 08-disk-first panelOrder 3
run_case 09-zoom-2x graphZoom 1 historyLength 1
run_case 10-zoom-4x graphZoom 2 historyLength 2
run_case 11-minimal profile 1
run_case 12-hardware profile 2
run_case 13-no-network showNetwork false
run_case 14-no-programs showPrograms false
run_case 15-no-hardware showHardware false
run_case 16-no-battery showBattery false
run_case 17-core-only showNetwork false showDisk false showPrograms false showHardware false showDisks false
run_case 18-dense-font fontScale 130 panelSpacing 2 panelOpacity 5 processCount 10 processSort 1
run_case 19-fan-target fanSpeedTarget 70

printf '\nScreenshots written to %s\n' "$SCREENSHOT_DIR"
printf 'Plasma log: %s\n' "$PLASMA_LOG"
