#!/usr/bin/env bash
set -euo pipefail

pick_menu() {
  if command -v rofi >/dev/null 2>&1; then
    rofi -dmenu -p "Power"
  elif command -v bemenu >/dev/null 2>&1; then
    bemenu -p "Power"
  else
    printf "%s\n" "Lock" "Sleep" "Reboot" "Shutdown" "Logout" | head -n1
    exit 0
  fi
}

lock_cmd() {
  if command -v hyprlock >/dev/null 2>&1; then
    hyprlock
  else
    loginctl lock-session || true
  fi
}

choice=$(printf "%s\n" "Lock" "Sleep" "Reboot" "Shutdown" "Logout" | pick_menu)
case "${choice:-}" in
  Lock)     lock_cmd ;;
  Sleep)    systemctl suspend ;;
  Reboot)   systemctl reboot ;;
  Shutdown) systemctl poweroff ;;
  Logout)   hyprctl dispatch exit 0 || true ;;
  *)        exit 0 ;;
esac
