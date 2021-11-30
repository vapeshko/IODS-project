# Valeria Peshko 23.11.2021
# Ex4 Data Wrangling

setwd("Z:/Documents/RProjects/IODS-project/data")

# read Human Development data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# read Gender Equality data
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# strucrure and dimensions of two data sets
library(dplyr)

glimpse(hd)
glimpse(gii)

# summaries of variables

summary(hd)
summary(gii)

# rename variables

hd <- rename(hd, HDIr = HDI.Rank)
hd <- rename(hd, HDI = Human.Development.Index..HDI.)
hd <- rename(hd, life_exp = Life.Expectancy.at.Birth)
hd <- rename(hd, exp_ed = Expected.Years.of.Education)
hd <- rename(hd, mean_ed = Mean.Years.of.Education)
hd <- rename(hd, GNIpc = Gross.National.Income..GNI..per.Capita)
hd <- rename(hd, GNIpcHDIr = GNI.per.Capita.Rank.Minus.HDI.Rank)

colnames(hd)

gii <- rename(gii, GIIr = GII.Rank)
gii <- rename(gii, GII = Gender.Inequality.Index..GII.)
gii <- rename(gii, adol_br = Adolescent.Birth.Rate)
gii <- rename(gii, mat_mr = Maternal.Mortality.Ratio)
gii <- rename(gii, rep_parl = Percent.Representation.in.Parliament)
gii <- rename(gii, sec_ed_f = Population.with.Secondary.Education..Female.)
gii <- rename(gii, sec_ed_m = Population.with.Secondary.Education..Male.)
gii <- rename(gii, lab_f = Labour.Force.Participation.Rate..Female.)
gii <- rename(gii, lab_m = Labour.Force.Participation.Rate..Male.)

colnames(gii)

# create new variables

gii <- mutate(gii, sec_ed_fm = sec_ed_f/sec_ed_m)

gii <- mutate(gii, lab_fm = lab_f/lab_m)


human <- inner_join(hd, gii, by = "Country")

# save new data set
write.csv(human, "human.csv")

# Ex 5 Data Wrangling

# structure of combined HDI (Human Development Index) 
# and GII (Gender Inequality Index) data sets
# by country

str(human) 
## 194 obs. 19 vars.

# change GNIpc into numeric variable
library(stringr)
human$GNIpc <- str_replace(human$GNIpc, pattern=",", replace ="") %>% as.numeric()
str(human$GNIpc)

# selecting variables
keep <- c("Country", "sec_ed_fm", "lab_fm", "exp_ed", "life_exp", "GNIpc", "mat_mr", "adol_br", "rep_parl")
human <- dplyr::select(human, one_of(keep))

# remove rows with NA
human2 <- filter(human, complete.cases(human))

# remove regions
tail(human2, 10)
human2 <- human2[1:155, ]

# define row names as countries
rownames(human2) <- human2$Country
human2 <- dplyr::select(human2, -Country)

# check resulting data set
str(human2)
## 155 observations and 8 variables

# saving
write.csv(human2, "human.csv")
