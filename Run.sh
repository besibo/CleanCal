#!/bin/bash
set -Eeuo pipefail

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

PROJECT_DIR="/Users/bsimonbo/Documents/TAF/Enseignements/CleanCal"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/cleancal.log"
LAST_SUCCESS_FILE="$LOG_DIR/last-success.txt"
MAIL_TO="besibo@gmail.com"

mkdir -p "$LOG_DIR"

send_failure_mail() {
  local exit_code="$1"
  local subject="[CleanCal] Echec du cron job"
  local body

  body=$(cat <<EOF
Le cron job CleanCal a echoue.

Date: $(date)
Machine: $(hostname)
Dossier: $PROJECT_DIR
Code de sortie: $exit_code

Dernieres lignes du log:

$(tail -n 80 "$LOG_FILE" 2>/dev/null || true)
EOF
)

  if command -v mail >/dev/null 2>&1; then
    printf '%s\n' "$body" | mail -s "$subject" "$MAIL_TO" || true
  else
    printf '%s\n' "Impossible d'envoyer l'alerte: commande mail introuvable." >&2
  fi
}

on_error() {
  local exit_code="$?"
  echo "[$(date)] ERROR CleanCal failed with exit code $exit_code"
  send_failure_mail "$exit_code"
  exit "$exit_code"
}

trap on_error ERR

{
  echo "[$(date)] Starting CleanCal update"

  cd "$PROJECT_DIR"

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
