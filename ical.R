# https://apps.univ-lr.fr/serveur-planning/wa/iCalendarOccupations?login=bsimonbo
# webcal://p102-caldav.icloud.com/published/2/MjcyNjgwNDg2MjcyNjgwND_YU539OaozOfWy5cUH5FiEGqtmCCXH98FcbzWAy2PjpfCqVv5Em9yCzbrSb3qFTrnJZsLHs6-lmLlJM9y3SBU
# Rscript ~/Desktop/cal/ical.R

options(tidyverse.quiet = TRUE)

# install.packages("calendar")
library(calendar)
library(tidyverse)

ic_read("https://apps.univ-lr.fr/serveur-planning/wa/iCalendarOccupations?login=bsimonbo") %>% 
  mutate(SUMMARY = str_remove(SUMMARY, "^B.Simon-bouhet  - "),
         DESCRIPTION = str_remove(DESCRIPTION, "B.Simon-bouhet  - "),
         SUMMARY = str_remove(SUMMARY, "^C\\d{1}-.{14}"),
         DESCRIPTION = str_remove(DESCRIPTION, "^C\\d{1}-.{14}")) %>% 
  ic_write(file = "~/Desktop/CleanCal/Data/res.ics")
