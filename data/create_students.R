# Valeria Peshko 19.11.2021
# Ex3 Data Wrangling

# Student Performance Data Set
# Data set accessed from UCI Machine Learning Repository
# Source: Paulo Cortez, University of Minho, Portugal

# reding the two data sets
student_mat <- read.table("student-mat.csv", header = TRUE, sep = ";")
student_por <- read.table("student-por.csv", header = TRUE, sep = ";")

# structure and dimensions
glimpse(student_mat)

glimpse(student_por)

# Define own id for both datasets
library(dplyr)
por_id <- student_por %>% mutate(id=1000+row_number()) 
math_id <- student_mat %>% mutate(id=2000+row_number())

# which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# the rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

# joining two data sets
mat_por <- inner_join(student_mat, student_por, by = join_cols, suffix = c(".mat", ".por"))

# exploring structure and dimensions of the new data set
glimpse(mat_por)

# crearing a new dataframe
students <- select(mat_por, one_of(join_cols))

# updating notjoined columns vector
free_cols <- c("failures","paid","absences","G1","G2","G3")       

# adding means of notjoined columns to new dataframe 
for(col_name in free_cols) {
  two_columns <- select(mat_por, starts_with(col_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    students[col_name] <- round(rowMeans(two_columns))
  } else {
    students[col_name] <- first_column
  }
}

# srtucrure of new data set
glimpse(students)

# creating new alcohol intake variable
students <- mutate(students, alc_use = (Dalc + Walc) / 2)

# creating new logical variable
students <- mutate(students, high_use = alc_use > 2)

# looking at the data set structure once again
glimpse(students)

# save joined data set
write.csv(mat_por, "mat_por.csv", row.names = TRUE)

# save modified data set
write.csv(students, "students.csv", row.names = TRUE)
