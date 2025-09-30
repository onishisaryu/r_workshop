# R Fundamentals Workshop (Structuring R Code)

# libraries at the top ####
library(tidyverse)
# options
options(readr.show_col_types = FALSE)
options(digits = 2)

# data next 
data <- read_csv('sampleData/dplyr2.csv')

# data processing
complete_data <-
  data %>%
  mutate(vo2_rel = vo2 * 1000 / weight , # ml/kg/min
         hr_max = 220 - age,
         hr_pct = hr / hr_max * 100)

# conduct analysis
