#!/usr/bin/env bash
set -euo pipefail

NETLOGO_REPO="${NETLOGO_REPO:-/Volumes/2TB_unclassified/projects/NetLogo_}"
cd "$NETLOGO_REPO"

echo "PWD: $(pwd)"
[[ -f "build.sbt" ]] || { echo "ERROR: build.sbt not found in $(pwd). Is NETLOGO_REPO correct?"; exit 1; }

export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"

echo "JAVA_HOME=$JAVA_HOME"
echo "java: $(command -v java)"
java -version

command -v sbt >/dev/null || { echo "sbt not found on PATH"; exit 1; }
echo "sbt:  $(command -v sbt)"
sbt --version || true

echo "Checking for ColorPicker staged assets (best-effort)..."
find . -maxdepth 6 \( -iname "*colorpicker*" -o -path "*ColorPicker*" \) -type f \
  \( -name "*.css" -o -name "*.js" -o -name "*.html" \) \
  | head -n 30 || true

if [[ "${1:-}" == "clean" ]]; then
  sbt -no-colors clean
fi

sbt -no-colors netlogo/run
