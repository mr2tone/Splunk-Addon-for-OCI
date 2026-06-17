#!/usr/bin/env bash
# package-addon.sh — build TA-oci-logging-addon.tgz from the addon source.
# Run inside the builder container: docker compose exec builder bash /addon/scripts/package-addon.sh
# Output: /dist/TA-oci-logging-addon.tgz  (also printed to stdout)
set -euo pipefail

ADDON_DIR=/addon
DIST_DIR=/dist
PKG_NAME=TA-oci-logging-addon
OUT="$DIST_DIR/${PKG_NAME}.tgz"

mkdir -p "$DIST_DIR"

# Build a clean tarball — strip .git, scripts/, requirements*.txt, pyc/pycache,
# and any dist-info metadata (not needed inside Splunk).
tar -czf "$OUT" \
  -C "$ADDON_DIR" \
  --exclude='./.git' \
  --exclude='./scripts' \
  --exclude='./requirements*.txt' \
  --exclude='./__pycache__' \
  --exclude='./**/__pycache__' \
  --exclude='./*.pyc' \
  --exclude='./**/*.pyc' \
  --transform "s|^\./|${PKG_NAME}/|" \
  .

SIZE=$(du -sh "$OUT" | cut -f1)
echo ">> Packaged ${OUT}  (${SIZE})"
echo ">> Contents preview (top-level):"
tar -tzf "$OUT" | grep -E "^${PKG_NAME}/[^/]+/?$" | sort
