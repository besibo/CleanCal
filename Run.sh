#!/bin/bash
set -Eeuo pipefail

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

PROJECT_DIR="/Users/bsimonbo/Documents/TAF/Enseignements/CleanCal"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/cleancal.log"
LAST_SUCCESS_FILE="$LOG_DIR/last-success.txt"

mkdir -p "$LOG_DIR"

send_failure_notification() {
  local exit_code="$1"

  if command -v osascript >/dev/null 2>&1; then
    osascript - "$exit_code" "$PROJECT_DIR" "$LOG_FILE" <<'APPLESCRIPT' \
      || true
on run argv
  set exitCode to item 1 of argv
  set projectDir to item 2 of argv
  set logFile to item 3 of argv
  set messageText to "La mise à jour du calendrier CleanCal a échoué." & return & return & "Le calendrier abonné n'est peut-être plus à jour." & return & return & "Code de sortie : " & exitCode & return & "Log : " & logFile

  set userChoice to button returned of (display dialog messageText with title "CleanCal a echoue" buttons {"Ignorer", "Afficher"} default button "Afficher" with icon caution)

  if userChoice is "Afficher" then
    set projectFolder to POSIX file projectDir as alias
    tell application "Finder"
      open projectFolder
      activate
    end tell
  end if
end run
APPLESCRIPT
  else
    printf '%s\n' "Impossible d'afficher l'alerte: commande osascript introuvable." >&2
  fi
}

on_error() {
  local exit_code="$?"
  echo "[$(date)] ERROR CleanCal failed with exit code $exit_code"
  send_failure_notification "$exit_code"
  exit "$exit_code"
}

trap on_error ERR

{
  echo "[$(date)] Starting CleanCal update"

  cd "$PROJECT_DIR"

  if [[ "${CLEANCAL_FORCE_FAILURE:-0}" == "1" ]]; then
    echo "[$(date)] Forced failure requested for alert testing"
    false
  fi

  Rscript -e "missing <- setdiff(c('calendar', 'tidyverse'), rownames(installed.packages())); if (length(missing)) stop('Missing R package(s): ', paste(missing, collapse = ', '), call. = FALSE)"
  Rscript ical.R
  # Rscript -e "bookdown::render_book()"

  git add docs/data/res.ics

  if git diff --cached --quiet; then
    echo "[$(date)] No calendar changes to commit"
  else
    git commit -m "Update calendar"
    git push origin main
  fi

  date > "$LAST_SUCCESS_FILE"
  echo "[$(date)] CleanCal update completed successfully"
} >> "$LOG_FILE" 2>&1
