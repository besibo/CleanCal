#!/bin/bash
export PATH="/usr/local/bin:$PATH"
Rscript /Users/bsimonbo/Documents/TAF/Enseignements/CleanCal/ical.R
# cd ~/Desktop/CleanCal/
# Rscript -e "bookdown::render_book()"
git add .
git commit -m "Update calendar"
git push origin main