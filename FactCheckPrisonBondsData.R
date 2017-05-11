### Fact-Checking Prison Bonds Statistic ###

# Set Up ------------------------------------------------------------------

library(tidyverse)

prisonDataOriginal <- read.csv("~/Downloads/DCDF Public Records Request _ June July 2016.csv", head=TRUE, sep=",")

prisonData <- mutate(prisonDataOriginal, FullName = paste(Name_First, Name_Middle, Name_Last))
prisonData$Bond_Amount <- as.numeric(gsub('[$, ]', '', prisonData$Bond_Amount))


# Separate Those with No Bond ---------------------------------------------

bonds <- filter(prisonData, !(Bond_Type %in% c("NO BOND", "NB")) & !is.na(Bond_Amount)) %>% 
  group_by(FullName, Date_Confined) %>% 
  summarise(total_bond = sum(Bond_Amount), days_confined = max(DaysConfined), charge_days = max(DaysOnCharge))

no_bonds <- filter(prisonData, Bond_Type %in% c("NO BOND", "NB")) %>% group_by(FullName, Date_Confined) %>% 
  summarise(total_bond = sum(Bond_Amount), days_confined = max(DaysConfined), charge_days = max(DaysOnCharge))


# Calculations ------------------------------------------------------------

overall_number <- nrow(bonds) + nrow(no_bonds)
overall_no_bond <- nrow(no_bonds)
overall_high_bond <- filter(bonds, total_bond > 5000) %>% nrow()
overall_low_bond <- filter(bonds, total_bond <= 5000) %>% nrow()

long_stay_bonds <- filter(bonds, days_confined > 1)
long_stay_no_bonds <- filter(no_bonds, days_confined > 1)
number_long_stay <- nrow(long_stay_bonds) + nrow(long_stay_no_bonds)
num_long_stay_no_bond <- nrow(long_stay_no_bonds)
num_long_stay_high_bonds <- filter(long_stay_bonds, total_bond > 5000) %>% nrow()
num_long_stay_low_bonds <- filter(long_stay_bonds, total_bond <= 5000) %>% nrow()

