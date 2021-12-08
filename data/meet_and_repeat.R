# Valeriia Peshko
# Exercise 5: Data Wrangling 08.12.21

setwd("Z:/Documents/RProjects/IODS-project/data")

#libraries
library(tidyr)
library(dplyr)

# reading the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",sep = " ",header=TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",sep = "\t",header=TRUE)

# overview of the data
head(BPRS)
glimpse(BPRS) # consists of 40 rows and 11 cols

head(RATS)
glimpse(RATS) # consists of 16 rows and 13 cols

BPRS %>% group_by(treatment) %>% summarise(n = n(), mean_w0 = mean(week0), mean_w8 = mean(week8))

RATS %>% group_by(Group) %>% summarise(n = n(), mean_WD1 = mean(WD1), mean_WD64 = mean(WD64))

# transforming categorical variables
BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)

RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)

# transforming into long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

RATSL <- RATS %>% gather(key = days, value = weights, -ID, -Group)

# saving weeks and days as numbers
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
head(BPRSL)

RATSL <- RATSL %>% mutate(day = as.integer(substr(days, 3,3)))
head(RATSL)                           

# serious look at the data sets
glimpse(BPRSL) # consists of 360 rows and 5 cols
head(BPRSL)

BPRSL %>% group_by(treatment, week) %>% summarise(n = n(), mean_bprs = mean(bprs))

glimpse(RATSL) # consists of of 176 rows and 5 cols
head(RATSL)