# R Fundamentals Workshop — Live Code Demo (Fundimentals in R)
# ------------------------------------------#
# part 1: setting up your working environment 
# ------------------------------------------#
## 1) Working Directory ----
# starting point for program operations
getwd() 
# setwd("/path/to/your/folder")

## 2) Packages ----
# install.packages("tidyverse") # Install once
# load every session
library(tidyverse) # contains readr, dplyr, ggplot2, tidyr, purrr, tibble, stringr, forcats
library(readxl) # read excel files

library(stats) # base R stats
library(rstatix) # pipe friendly stats
library(psych) # psych stats

library(ggsignif) # Significance Brackets for 'ggplot2'

# for full list
library(help = "ggsignif") 

## 3) Objects & Environment ----
# Objects hold data and show up in the Environment.
x <- 5 # single integer
scores <- c(1, 2, 3) # a vector of integers


# recall objects, print in console
x
scores

## 4) Import / Export Data  ----
# Reading and writing data is a common first hurdle. 
# instead of file -> import data -> ... Use readr for csv, readxl for excel files
read_csv("data/sample/cleanData.csv") 

# put it into an object to save it in the working environment
exceldata <- read_xlsx("data/sample/cleanData.xlsx", sheet = "cleanData")
clean_data <- read_csv("data/sample/cleanData.csv")

# use write_csv() carefully. it will override existing data.
write_csv(clean_data,"data/clean/workshop.csv")


#####
# ------------------------------ #
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
View(clean_data)

# view large data frames
head(clean_data)
summary(clean_data)
describe(clean_data) # from psych

## 2) Data Structure ----
# very important when doing any kind of data operation in R
# wide data - each row might represent one subject
read_csv("data/sample/wide.csv")

# long data - each row should be one data point
read_csv("data/sample/long.csv")
{sampleData_long  <- 
  read_csv("data/sample/wide.csv") %>% 
  pivot_longer(cols = -subject,
               names_to = c(".value","condition"),
               names_sep = "_")}

## 3) Data Processing with dplyr ----
raw_data <- read_csv('data/sample/dplyr.csv')

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

complete_data <- read_csv("data/sample/dplyr2.csv")

# mutate() to add a new column
final <- 
  complete_data %>%
  mutate(vo2_rel = vo2 * 1000 / weight , # ml/kg/min
         hr_max = 220 - age,
         hr_pct = hr / hr_max * 100)     # %HRmax
final

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

# stats package
cor.test(~HR+VO2, sampleData_long)
res <- cor.test(~HR+VO2, sampleData_long)
res$estimate # correlation estimate
res$statistic # t statistic
res$p.value # p value

t.test(VO2~condition, sampleData_long)
res <- t.test(VO2~condition, sampleData_long)
res$estimate
res$statistic
res$p.value

