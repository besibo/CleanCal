#!/bin/bash
export PATH="/usr/local/bin:$PATH"

Rscript ical.R
cd /Users/bsimonbo/Documents/TAF/Enseignements/CleanCal/
# Rscript -e "bookdown::render_book()"

git add .
git commit -m "Update calendar"
git push origin main