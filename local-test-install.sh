#!/usr/bin/env bash
set -euo pipefail

TAP_NAME="seemueller-io/homebrew-tap"
FORMULA_NAME="mlx-omni-server"

cd "$(dirname "$0")"

echo "🔁 Retapping $TAP_NAME..."
brew untap "$TAP_NAME" >/dev/null 2>&1 || true
brew tap "$TAP_NAME" .

# Always copy latest local formula into active Homebrew tap
cp "Formula/${FORMULA_NAME}.rb" "$(brew --repo "$TAP_NAME")/Formula/${FORMULA_NAME}.rb"

echo "🧪 Building ${FORMULA_NAME} from source..."
brew uninstall -f "$FORMULA_NAME" >/dev/null 2>&1 || true
brew reinstall --build-from-source "$TAP_NAME/$FORMULA_NAME"

echo "✅ Done. Try:"
echo "   $FORMULA_NAME --help"

#brew audit --strict Formula/mlx-omni-server.rb)