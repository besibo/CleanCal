#!/bin/bash
Rscript ical.R
# cd ~/Desktop/CleanCal/
Rscript -e "bookdown::render_book()"
git add .
git commit -m "Update calendar"
git push origin main