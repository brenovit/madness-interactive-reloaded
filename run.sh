#!/usr/bin/env bash
# Sets up what's missing, builds and runs Madness Interactive Reloaded on macOS or Linux.
#
#   ./run.sh                 Debug build, then run
#   ./run.sh --release       Release build, then run
#   ./run.sh --build-only    Build without running
#   ./run.sh -- <args>       Pass the rest of the arguments to the game
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$ROOT/src/MadnessInteractiveReloaded"
CONFIG=Debug
RUN=1
GAME_ARGS=()

while [[ $# -gt 0 ]]; do
	case "$1" in
		--release) CONFIG=Release ;;
		--build-only) RUN=0 ;;
		--) shift; GAME_ARGS=("$@"); break ;;
		-h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
		*) echo "Unknown option: $1 (see --help)" >&2; exit 1 ;;
	esac
	shift
done

step() { printf '\n==> %s\n' "$*"; }

OS="$(uname -s)"

# --- Setup ---------------------------------------------------------------

if [[ "$OS" == "Darwin" ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo "Homebrew is required on macOS: https://brew.sh" >&2
		exit 1
	fi
	if ! command -v dotnet >/dev/null 2>&1; then
		step "Installing the .NET SDK"
		brew install --cask dotnet-sdk
	fi
	# The game uses FFmpeg 5.1 for cutscenes; newer FFmpeg versions are not compatible.
	if ! brew list --versions ffmpeg@5 >/dev/null 2>&1; then
		step "Installing ffmpeg@5"
		brew install ffmpeg@5
	fi
	FFMPEG_LIB="$(brew --prefix ffmpeg@5)/lib"
	export DYLD_LIBRARY_PATH="$FFMPEG_LIB${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"
elif ! command -v dotnet >/dev/null 2>&1; then
	echo "The .NET SDK (9 or newer) is required: https://dotnet.microsoft.com/download" >&2
	exit 1
fi

if [[ ! -f "$ROOT/src/Harmony/Harmony/Harmony.csproj" || ! -f "$ROOT/src/BigGustave/src/BigGustave/BigGustave.csproj" ]]; then
	step "Initialising submodules"
	git -C "$ROOT" submodule update --init --recursive
fi

# --- Build ---------------------------------------------------------------

step "Building ($CONFIG)"
dotnet build "$PROJECT_DIR/MIR.csproj" -c "$CONFIG" -nologo -v quiet -clp:ErrorsOnly

# --- Run -----------------------------------------------------------------

[[ "$RUN" == 1 ]] || exit 0

OUT_DIR="$PROJECT_DIR/bin/$CONFIG/net9.0"
step "Running"
cd "$OUT_DIR"
exec dotnet MIR.dll ${GAME_ARGS[@]+"${GAME_ARGS[@]}"}
