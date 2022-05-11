#!/bin/bash
export PATH="/usr/local/bin:$PATH"
/usr/local/bin/Rscript ical.R
# cd ~/Desktop/CleanCal/
/usr/local/bin/Rscript -e "bookdown::render_book()"
git add .
git commit -m "Update calendar"
git push origin main