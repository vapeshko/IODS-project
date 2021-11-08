# Valeria Peshko 8.11.2021
# Ex2 Data Wrangling
lrn14 <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt",sep = "\t",header=TRUE)# dimensions of the data

# dimensions of the data
dim(lrn14)

# structure of the data
str(lrn14)

library(dplyr)

#combining variables
deep_columns <-select(lrn14, one_of(c("D11","D14","D15","D19","D22","D23","D27","D30","D31")))
surface_columns <-select(lrn14, one_of(c("SU02","SU10","SU18","SU26","SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")))
strategic_columns<-select(lrn14, one_of(c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")))

#creating learning2014 dataset
learning2014 <- select(lrn14, one_of(c("gender","Age","Attitude", "Points")))
colnames(learning2014)[2]<- "age"
colnames(learning2014)[3]<- "attitude"
colnames(learning2014)[4]<- "points"
learning2014$deep <- rowMeans(deep_columns)
learning2014$surf <- rowMeans(surface_columns)
learning2014$stra <- rowMeans(strategic_columns)
learning2014 <- filter(learning2014, points>0)

# see structure of learning2014
str(learning2014)
learning2014

# saving new dataset
write.table(learning2014, file = "learning2014.csv", sep = ",", col.names = NA, qmethod = "double")

#reading csv file
read.table("learning2014.csv", header = TRUE, sep = ",", row.names = 1)
