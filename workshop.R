# R Fundamentals Workshop — Live Code Demo (Teaching Script)
##############################################
# part 1: setting up your working environment 
# ------------------------------------------#
## 1) Working Directory ----
# starting point for program operations
getwd() 
# setwd("/path/to/your/folder")
# setwd("/Users/saryu/Library/CloudStorage/OneDrive-UniversityofOklahoma")

## 2) Packages ----
# Install once; load every session
install.packages("tidyverse")
# contains readr, dplyr, ggplot2, tidyr, purrr, tubble, stringr, forcats
library(tidyverse) 
# read excel files
library(readxl)
# stats
library(stats)
library(rstatix)
library(psych)
library(lavaan)
# publication plots
library(ggsignif)
# for full list
library(help = "rstatix")


## 3) Objects & Environment ----
# Objects hold data and show up in the Environment.
x <- 5 # single integer
scores <- c(1, 2, 3) # a vector of integers
# print in console
x
scores

## 4) Import / Export Data  ----
# Reading and writing data is a common first hurdle. 
## instead of file -> import data -> ...
## Use readr for csv, readxl for excel files
# Demo read:
read_csv("sample/cleanData.csv")
sample <- read_csv("sample/cleanData.csv")

# Demo writes:
# write_csv(sample, "sample/mydata.csv")

##################################
# part 2: working with the data 
# ------------------------------ #
## 1) Data Frames (Tables) ----
# Data frames/tibbles are like spreadsheets in R.
gradebook <- data.frame(
  name  = c("aaron", "jacqueline", "blake"),
  score = c(55, 22, 80)
)

# view small data frames
View(gradebook)
View(sample)

# view large data frames
head(sample)
summary(sample)
describe(sample) # from psych

## 2) Data Structure ----
# very important when doing any kind of data operation in R
# wide data - each row might represent one subject
sample_wide <-
  data.frame(
    subject = c("A", "B", "C"),
    HR_rest = c(60, 72, 68),      # heart rate at rest
    HR_post = c(150, 160, 140),   # heart rate after exercise
    VO2_rest = c(3.2, 2.8, 3.0),  # VO2 (ml/kg/min) at rest
    VO2_post = c(38.5, 42.0, 35.2) # VO2 after exercise
  )
View(sample_wide)

# long data - each row should be one data point
sample_long  <- 
  sample_wide %>% 
  pivot_longer(cols = -subject,
               names_to = c(".value","condition"),
               names_sep = "_")
sample_long

## simple data operations ----
# pull out values from a column
sample_long[,4]  # position index
sample_long[[4]]  # position  index
sample_long$VO2 # name index

# column names
names(sample_long)
colnames(sample_long)

# doing calculations
mean(sample_long$VO2)

cor(sample_long$HR,sample_long$VO2)

## 3) dplyr ----

raw_data <- read_csv('sample/dplyr.csv')

join_data <- tibble(subject = c('A01','A02','A03'),
                    weight  = c(89,65,75),
                    age     = c(37,50,30))

complete_data <- raw_data %>% inner_join(join_data, by = 'subject')
# The pipe %>% strings steps together like sentences.
# select() to select columns
complete_data %>% select(hr, vo2)
# same as 
select(complete_data, hr, vo2)
complete_data %>% select(., hr, vo2)

# Filter() to ... filter data
complete_data  %>%
  filter(subject == 'A01')


# mutate() to add a new column
complete_data <-
  complete_data %>%
  mutate(vo2_rel = vo2 * 1000 / weight , # ml/kg/min
         hr_max = 220 - age,
         hr_pct = hr / hr_max * 100)     # %HRmax

# Add columns and summarise
complete_data %>%
  group_by(subject) %>%
  summarise(hr_avg = mean(hr), 
            stage_count = n())
## 4) ggplot2 (Tiny Teaser) ----
# Grammar of graphics: data + aesthetics + geometry.
complete_data %>%
  ggplot(aes(x = workload_watts, y = vo2_rel, color = subject)) +
  geom_point() +
  geom_line(linetype = 2)

join_data %>% 
  ggplot(aes(subject, age)) +
  geom_col()

## 1) Control Flow ----
# You won't need these every day, but you'll see them in examples.
for (i in 1:3) {
  print(i)
}

x <- gradebook %>% filter(name == "aaron") %>% pull(score)
if (x > 50) {
  print("aaron passed")
}

## 2) Functions (Built-in vs Custom) ----
# Functions are recipes: inputs -> output. Write your own to remove repetition.
mean(c(1, 2, 3, 4))  # built-in

add_one <- function(x) {
  x + 1
}
add_one(10)

# Appendix: Common Gotchas & Shortcuts -----
# - Pipe shortcut (RStudio): Cmd/Ctrl + Shift + M inserts %>%
# - Help: ?function_name  (e.g., ?mutate)
# - Inspect quickly: str(df), dplyr::glimpse(df), head(df), summary(df)
# - Factors vs characters: prefer tibble(); in base data.frame() use stringsAsFactors=FALSE (older R)
# - Reproducibility: use R Projects and relative paths (e.g., here::her