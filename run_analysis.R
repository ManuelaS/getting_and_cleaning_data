# Getting and Cleaning Data - Course Project

# Setup
# Set working directory
setwd("F:/coursera/getting_and_cleaning_data/course_project")
# Clean up workspace
rm(list=ls())
# Load libraries (or install if required)
if (!require('data.table')) {
  install.packages('data.table')
}
if (!require('plyr')) {
  install.packages('plyr')
}
if (!require('dplyr')) {
  install.packages('dplyr')
}

library(data.table)
library(plyr)
library(dplyr)


# STEP 0: Download dataset
# Download and unzip the dataset:
if (!file.exists('UCI HAR Dataset')){
  file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(file_url,'./data.zip')
    unzip('./data.zip')
}  

# STEP 1: Merge the training and the test sets to create one data set.
# Load and merge measurements data
train_data <- read.table('UCI HAR Dataset/train/X_train.txt',header=FALSE)
test_data <- read.table('UCI HAR Dataset/test/X_test.txt',header=FALSE)
data <- rbind(train_data,test_data)
# Load feature labels and use to label data
features <- read.table('UCI HAR Dataset/features.txt',col.names=c('feature_id','features_name'))
names(data) <- features$features_name

# Load and merge activities' labels
train_activities <- read.table('UCI HAR Dataset/train/Y_train.txt',header=FALSE)
test_activities <- read.table('UCI HAR Dataset/test/Y_test.txt',header=FALSE)
activities <- rbind(train_activities,test_activities)
names(activities) <- c('activity_id')
# Load and merge subjects' labels
train_subjects <- read.table('UCI HAR Dataset/train/subject_train.txt')
test_subjects <- read.table('UCI HAR Dataset/test/subject_test.txt')
subjects <- rbind(train_subjects,test_subjects)
names(subjects) <- c('subjects')
# Merge measurements data, activities' and subjects' labels
complete_dataset <- cbind(subjects,activities,data)
# Visually inspect data
glimpse(complete_dataset)

# STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.
# Find columns with mean- and std- related measurements
columns_with_mean_or_std <- grep('mean|std',features$features_name)
columns_to_keep <- c(1:2,columns_with_mean_or_std+2)
data_mean_std_only <- complete_dataset[,columns_to_keep]

# STEP 3: Use descriptive activity names to name the activities in the data set.
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt',col.names=c('activity_id','activity_name'))
data_mean_std_only2 <- join(data_mean_std_only,activity_labels,by='activity_id')

# STEP 4: Appropriately label the data set with descriptive activity names.
# Check activity names
names(data_mean_std_only2)
# Remove brackets for readability
names(data_mean_std_only2) <- gsub('[()]','',names(data_mean_std_only2))
# Rename mean and std
names(data_mean_std_only2) <- gsub('-mean-','Mean',names(data_mean_std_only2))
names(data_mean_std_only2) <- gsub('-std-','StDev',names(data_mean_std_only2))
# Rename f and t
names(data_mean_std_only2) <- gsub('^t','Time',names(data_mean_std_only2))
names(data_mean_std_only2) <- gsub('^f','Frequency',names(data_mean_std_only2))
# Spell out names for added clarity
names(data_mean_std_only2) <- gsub('Acc','Acceleration',names(data_mean_std_only2))
names(data_mean_std_only2) <- gsub('Mag','Magnitude',names(data_mean_std_only2))
names(data_mean_std_only2) <- gsub('gravity','Gravity',names(data_mean_std_only2),ignore.case=TRUE)
names(data_mean_std_only2) <- gsub('body|BodyBody','Body',names(data_mean_std_only2),ignore.case=TRUE)

# Check naming again
names(data_mean_std_only2)

# STEP 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_by_activities_subject <- group_by(data_mean_std_only2,activity_name,subjects) %>%
 summarise_each(funs(mean))
# Sanity check:
#    * number of patients: n_distinct(unique(data_by_activities_subject$subjects))
#    * number of activities: n_distinct(unique(data_by_activities_subject$activity_name))
# We expect a tidy dataset of 30*6 rows
nrow(data_by_activities_subject)
# Write to file with row names set to FALSE as per instructions
write.table(data_by_activities_subject,file='tidy_dataset.txt',row.name=FALSE)