#!/usr/bin/env bash
# Launcher for Procedural GPU Patterns - 3D Room Simulation

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect Godot binary
GODOT_BIN=""
if [ -x "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    GODOT_BIN="/Applications/Godot.app/Contents/MacOS/Godot"
elif command -v godot &> /dev/null; then
    GODOT_BIN="godot"
elif command -v godot4 &> /dev/null; then
    GODOT_BIN="godot4"
fi

if [ -z "$GODOT_BIN" ]; then
    echo "Godot 4 executable not found in PATH or /Applications/Godot.app."
    echo "Please open Godot 4 and import the project from: $DIR/10-curled-noise"
    exit 1
fi

echo "Launching Procedural GPU Patterns 3D Room Simulation..."
"$GODOT_BIN" --path "$DIR/10-curled-noise" "$@"
