#!/bin/bash
export PATH="/usr/local/bin:$PATH"

Rscript ical.R

Rscript -e 'options(tidyverse.quiet = TRUE) ; library(tidyverse) ; calendar::ic_read("https://apps.univ-lr.fr/serveur-planning/wa/iCalendarOccupations?login=bsimonbo") %>% 
  mutate(SUMMARY = str_remove(SUMMARY, "^B.Simon-bouhet  - "),
         SUMMARY = str_remove(SUMMARY, "^B. Simon-bouhet  - "),
         SUMMARY = str_remove(SUMMARY, "^C\\d{1}-.{14}"),
         SUMMARY = str_remove(SUMMARY, "\\d{3}-\\d{1}-\\d{2}.{3}"),
         DESCRIPTION = str_remove(DESCRIPTION, "B.Simon-bouhet  - "),
         DESCRIPTION = str_remove(DESCRIPTION, "B. Simon-bouhet  - "),
         DESCRIPTION = str_remove(DESCRIPTION, "^C\\d{1}-.{14}"),
         DESCRIPTION = str_remove(DESCRIPTION, "\\d{3}-\\d{1}-\\d{2}.{3}")) %>% calendar::ic_write(tmp, file = "/Users/bsimonbo/Documents/TAF/Enseignements/CleanCal/docs/data/res.ics")
'

cd /Users/bsimonbo/Documents/TAF/Enseignements/CleanCal/
# Rscript -e "bookdown::render_book()"

git add .
git commit -m "Update calendar"
git push origin main
