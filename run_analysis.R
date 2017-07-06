###################### Load Data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
              , destfile = 'Dataset.zip')
unzip("Dataset.zip")

## Handle the train data
features <- readLines("./UCI HAR Dataset/features.txt")                                           # read features
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features)                # read x_train with features as column names
activity_labels <- readLines("./UCI HAR Dataset/activity_labels.txt")                             # read activity labels
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")              # read y_train with Activity as column name
y_train$Activity <- factor(y_train$Activity, levels = c(1,2,3,4,5,6), 
                  labels = activity_labels)                                                       # Activity as factor
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = 'Subject')   # read the subjects
train <- cbind(subject_train,y_train,X_train)                                                     # Combine the tables to one train dataset


## Handle the test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features)                   # read x_test with features as column names
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")                 # read y_test with Activity as column name
y_test$Activity <- factor(y_test$Activity, levels = c(1,2,3,4,5,6), 
                           labels = activity_labels)                                              # Activity as factor
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = 'Subject')      # read the subjects
test <- cbind(subject_test,y_test,X_test)                                                         # Combine the tables to one test dataset

## Merge train and test, and filter for certain columns
library(dplyr)
data <- rbind(train, test)                                                                        # Merge the test and train dataset
data <- data %>% select(matches('Activity|Subject|mean\\.|std'))                                  # Keep only columns we want
tidydata <- data %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))                    # Group by and create mean for all columns
write.table(tidydata, 'tidydata.txt')                                                             # Write the tidy data set
