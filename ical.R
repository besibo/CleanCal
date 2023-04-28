`# https://apps.univ-lr.fr/serveur-planning/wa/iCalendarOccupations?login=bsimonbo
# webcal://p102-caldav.icloud.com/published/2/MjcyNjgwNDg2MjcyNjgwND_YU539OaozOfWy5cUH5FiEGqtmCCXH98FcbzWAy2PjpfCqVv5Em9yCzbrSb3qFTrnJZsLHs6-lmLlJM9y3SBU
# Rscript ~/Desktop/cal/ical.R

options(tidyverse.quiet = TRUE)

# install.packages("calendar")
library(calendar)
library(tidyverse)

tmp <- ic_read("https://apps.univ-lr.fr/serveur-planning/wa/iCalendarOccupations?login=bsimonbo") 

ic_write(tmp, file = "/Users/bsimonbo/Documents/TAF/Enseignements/CleanCal/docs/data/res.ics")
