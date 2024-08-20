#!/usr/bin/env sh

# exit on ignored non-0 exit
set -e

rclone_sync() {
  rclone sync \
    --create-empty-src-dirs \
    --check-first \
    --checksum \
    --metadata \
    --update \
    "$1" "$2" $args
}

sync() {
  rclone_sync "$1" "$2"
  rclone_sync "$2" "$1"
}

args=$@

# Only run once
# grep + self
if [ "$(ps aux | grep \"$0\" | wc -l)" -gt 2 ]; then
  printf "Already running, skipping\n"
  exit 1
fi

START=$(date +%s)
ID=$(notify-send --print-id "$(basename $0)" "starting backup") || true

sync proton:Utils ~/Utils
sync proton:Documents ~/Documents

END=$(date +%s)
DIFF=$(( $END - $START ))
notify-send --replace-id="$ID" "$(basename $0)" "finished backup in $DIFF seconds" || true
