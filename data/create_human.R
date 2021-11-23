# Valeria Peshko 23.11.2021
# Ex4 Data Wrangling

# read Human Development data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# read Gender Equality data
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# strucrure and dimensions of two data sets
library(dplyr)

glimpse(hd)
glimpse(gii)

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

gii <- mutate(gii, sec_ed_rat = sec_ed_f/sec_ed_m)
print(gii$sec_ed_rat)

gii <- mutate(gii, lab_rat = lab_f/lab_m)
print(gii$lab_rat)

human <- inner_join(hd, gii, by = "Country")
glimpse(human)

# save new data set
write.csv(human, "human.csv")
