# https://apps.univ-lr.fr/serveur-planning/wa/iCalendarOccupations?login=bsimonbo
# webcal://p102-caldav.icloud.com/published/2/MjcyNjgwNDg2MjcyNjgwND_YU539OaozOfWy5cUH5FiEGqtmCCXH98FcbzWAy2PjpfCqVv5Em9yCzbrSb3qFTrnJZsLHs6-lmLlJM9y3SBU
# Rscript ~/Desktop/cal/ical.R

options(tidyverse.quiet = TRUE)

# install.packages("calendar")
library(calendar)
library(tidyverse)

ic_read("https://apps.univ-lr.fr/cgi-bin/WebObjects/ServeurPlanning.woa/wa/iCalendarOccupations?login=bsimonbo") %>% 
  mutate(SUMMARY = str_remove_all(SUMMARY, "^B.Simon-bouhet  - "),
         SUMMARY = str_remove_all(SUMMARY, "^B. Simon-bouhet  - "),
         SUMMARY = str_remove_all(SUMMARY, "\\\\\\; Outils pour l'étude et la compréhension du vivant "),
         SUMMARY = str_remove_all(SUMMARY, "\\\\\\; SIMON-BOUHET Benoit \\[EDT\\]"),
         SUMMARY = str_remove_all(SUMMARY, "^C\\d{1}-.{14}"),
         SUMMARY = str_remove_all(SUMMARY, "\\d{3}-\\d{1}-\\d{2}.{3}"),
         DESCRIPTION = str_remove_all(DESCRIPTION, "B.Simon-bouhet  - "),
         DESCRIPTION = str_remove_all(DESCRIPTION, "^C\\d{1}-.{14}"),
         DESCRIPTION = str_remove_all(DESCRIPTION, "B. Simon-bouhet  - "),
         DESCRIPTION = str_remove_all(DESCRIPTION, "\\\\\\; Outils pour l'étude et la compréhension du vivant "),
         DESCRIPTION = str_remove_all(DESCRIPTION, "\\\\\\; SIMON-BOUHET Benoit \\[EDT\\]"),
         DESCRIPTION = str_remove_all(DESCRIPTION, "\\d{3}-\\d{1}-\\d{2}.{3}")) %>%
  ic_write(file = "/Users/bsimonbo/Documents/TAF/Enseignements/CleanCal/docs/data/res.ics")
