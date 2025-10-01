# R Fundamentals Workshop — Live Code Demo (Fundimentals in R)
##############################################
# part 1: setting up your working environment 
# ------------------------------------------#
## 1) Working Directory ----
# starting point for program operations
getwd() 
# setwd("/path/to/your/folder")

## 2) Packages ----
# Install once; load every session
# install.packages("tidyverse")
library(tidyverse) # contains readr, dplyr, ggplot2, tidyr, purrr, tibble, stringr, forcats
library(readxl) # read excel files
library(stats) # base R stats
library(rstatix) # pipe friendly stats
library(psych) # psych stats
library(lavaan) # latent variable stats
library(ggsignif) # Significance Brackets for 'ggplot2'
# for full list
library(help = "ggsignif") 

## 3) Objects & Environment ----
# Objects hold data and show up in the Environment.
x <- 5 # single integer
scores <- c(1, 2, 3) # a vector of integers
# print in console
x
scores

## 4) Import / Export Data  ----
# Reading and writing data is a common first hurdle. 
# instead of file -> import data -> ...
# Use readr for csv, readxl for excel files
read_csv("sampleData/cleanData.csv") 

# put it into an object to save it in the working environment
sampleData <- read_xlsx("sampleData/cleanData.xlsx", sheet = "cleanData")
sampleData <- read_csv("sampleData/cleanData.csv")


# Demo writes:
# write_csv(sampleData, "sample/mydata.csv")

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
View(sampleData)

# view large data frames
head(sampleData)
summary(sampleData)
describe(sampleData) # from psych

## 2) Data Structure ----
# very important when doing any kind of data operation in R
# wide data - each row might represent one subject
{sampleData_wide <-
  data.frame(
    subject = c("A", "B", "C"),
    HR_rest = c(60, 72, 68),      # heart rate at rest
    HR_post = c(150, 160, 140),   # heart rate after exercise
    VO2_rest = c(3.2, 2.8, 3.0),  # VO2 (ml/kg/min) at rest
    VO2_post = c(38.5, 42.0, 35.2) # VO2 after exercise
  )}
# View(sampleData_wide)
sampleData_wide

# long data - each row should be one data point
{sampleData_long  <- 
  sampleData_wide %>% 
  pivot_longer(cols = -subject,
               names_to = c(".value","condition"),
               names_sep = "_")}
sampleData_long

## 3) dplyr ----
raw_data <- read_csv('sampleData/dplyr.csv')

# The pipe %>% strings steps together like sentences.
# select() to select columns
raw_data %>% select(hr, vo2)
# same as 
select(raw_data, hr, vo2)
raw_data %>% select(., hr, vo2)
raw_data[c('hr','vo2')] # base R

# Filter() to ... filter data
raw_data %>% filter(subject == 'A01')
raw_data[(raw_data['subject']=='A01'), ] # base R subsetting

{# left_join or full_join
join_data <- tibble(subject = c('A01','A02','A03'),
                    weight  = c(89,65,75),
                    age     = c(37,50,30))

complete_data <- raw_data %>% inner_join(join_data, by = 'subject')}
complete_data
# complete_data %>% write_csv('sampleData/dplyr2.csv')

# mutate() to add a new column
final <- 
  complete_data %>%
  mutate(vo2_rel = vo2 * 1000 / weight , # ml/kg/min
         hr_max = 220 - age,
         hr_pct = hr / hr_max * 100)     # %HRmax

# convert data types
complete_data %>% 
  mutate(sex_factor = as_factor(sex),
         subject = as.character(subject),
         hr = as.numeric(hr),
         age = as.integer(age))

complete_data$baseRvo2_rel <- complete_data$vo2 * 1000 / complete_data$weight

# Add columns and summarise
final %>%
  group_by(subject) %>%
  # to collapse data into one row per group, use summarise()
  summarize(hr_avg = mean(hr), 
            stage_count = n())

## 3) Data Analysis ----
# basic mathematical operations

# simple data operations
# pull out values from a column
sampleData_long[,4]  # position index
sampleData_long[[4]]  # position  index
sampleData_long$VO2 # name index
sampleData_long %>% pull(VO2)

# column names
names(sampleData_long)

colnames(sampleData_long)

# doing calculations
mean(sampleData_long$VO2)
cor(sampleData_long$HR,sampleData_long$VO2)
# do other stats? t-test

###############
# Other stuff 
# ------------#
## ggplot2 ----
# Grammar of graphics: data + aesthetics + geometry.
final %>%
  ggplot(aes(x = workload_watts, y = vo2_rel, color = subject)) +
  geom_point() +
  geom_line(linetype = 2)

join_data %>% 
  ggplot(aes(subject, age)) +
  geom_col()
## Control Flow ----
# You won't need these every day, but you'll see them in examples.
for (i in 1:3) {
  print(i)
}

x <- gradebook %>% filter(name == "aaron") %>% pull(score)
if (x > 50) {
  print("aaron passed")
}

## Functions (Built-in vs Custom) ----
# Functions are recipes: inputs -> output. Write your own to remove repetition.
mean(c(1, 2, 3, 4))  # built-in

add_one <- function(x) {
  x + 1
}
add_one(10)

# ------------------------------ #
# Appendix: Common Gotchas & Shortcuts -----
# - Pipe shortcut (RStudio): Cmd/Ctrl + Shift + M inserts %>%
# - Help: ?function_name  (e.g., ?mutate)
# - Inspect quickly: str(df), dplyr::glimpse(df), head(df), summary(df)
# - Factors vs characters: prefer tibble(); in base data.frame() use stringsAsFactors=FALSE (older R)
# - Reproducibility: use R Projects and relative paths (e.g., here::her