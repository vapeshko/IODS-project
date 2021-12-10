# Valeriia Peshko
# Exercise 6: Data Wrangling 08.12.21

setwd("Z:/Documents/RProjects/IODS-project/data")

#libraries
library(tidyr)
library(dplyr)

# reading the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",sep = " ",header=TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",sep = "\t",header=TRUE)

# overview of the data
head(BPRS)
tail(BPRS)
glimpse(BPRS) 
## in the wide form the number of rows equals the number of subjects
## and bprs measurements are spread out between columns, representing particular time points
## consists of 40 rows and 11 cols

head(RATS)
tail(RATS)
glimpse(RATS) 
## consists of 16 rows for 16 subjects, and 13 cols, 11 of which record weight measurements on a particular day

# bprs means before and during last week of treatment by treatment group
BPRS %>% group_by(treatment) %>% summarise(n = n(), mean_w0 = mean(week0), mean_w8 = mean(week8))

# weight means on first and last day of measurements by groups
RATS %>% group_by(Group) %>% summarise(n = n(), mean_WD1 = mean(WD1), mean_WD64 = mean(WD64))

# creating id column in BPRS
num_sub <- nrow(BPRS)
BPRS <- BPRS %>% mutate(id = seq.int(num_sub) )

# transforming categorical variables
cat_vars <- c("treatment", "subject", "id")
BPRS[cat_vars] <- lapply(BPRS[cat_vars], factor)

cat_vars2 <- c("ID", "Group")
RATS[cat_vars2] <- lapply(RATS[cat_vars2], factor)

# transforming into long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject, -id)

RATSL <- RATS %>% gather(key = days, value = weights, -ID, -Group)

# saving weeks and days as numbers
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5, nchar(weeks))))

RATSL <- RATSL %>% mutate(day = as.integer(substr(days, 3, nchar(days))))
                           
# serious look at the data sets
head(BPRSL)
tail(BPRSL)
glimpse(BPRSL) 
## now in the long form the number of rows equals the total number of measurements taken
## all bprs measurements are stored in column 'bprs'
## all records of time are kept in column 'week'
## consists of 360 rows and 5 cols

head(RATSL)
tail(RATSL)
glimpse(RATSL)
## all weight measurements are stored in column 'weights'
## all records of time are kept in column 'day'
## consists of of 176 rows = number of measurements, and 5 cols

# summaries
## in the long form it is easier to show weekly means by groups
BPRSL %>% group_by(treatment, week) %>% summarise(num_subjects = n(), mean_bprs = mean(bprs))
RATSL %>% group_by(Group, day) %>% summarise(num_subjects = n(), mean_weight = mean(weights))

## we can also summarise all time points
BPRSL %>% group_by(treatment) %>% summarise(num_obs = n(), mean_bprs = mean(bprs), median_bprs = median(bprs), sd_bprs = sd(bprs))
RATSL %>% group_by(Group) %>% summarise(num_obs = n(), mean_weight = mean(weights), median_weight = median(weights), sd_weight = sd(weights))

# saving the data sets
write.csv(BPRSL, "BPRSL.csv", row.names = TRUE)
write.csv(RATSL, "RATSL.csv", row.names = TRUE)
