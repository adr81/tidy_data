## This script requires the dplyr package

## Please see the README.txt file for details on how this script works

library(dplyr)
library(reshape2)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

features <- read.table("./UCI HAR Dataset/features.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")

test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

train_set <- read.table("./UCI HAR Dataset/train/X_train.txt")

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")

l_test_set <- cbind(test_labels, subject_test, test_set)
l_train_set <- cbind(train_labels, subject_train, train_set)
rm(test_labels, subject_test, test_set, train_labels, subject_train, train_set)

feature_names <- make.names(features[, 2], unique = TRUE)
colnames(l_test_set) <- c("activity", "subject", feature_names)
colnames(l_train_set) <- c("activity", "subject", feature_names)

combined <- rbind(l_test_set, l_train_set)
rm(l_test_set, l_train_set)

extract <- select(combined, activity, subject, contains("Mean"), contains("std"))

extract <- merge(extract, activity_labels, by.x = "activity", by.y = "V1")
extract <- rename(extract, activity_name = V2)

variables <- colnames(extract)
extract_melt <- melt(extract, id = c("subject", "activity_name"), measure.vars = variables[-c(1, 2, 89)])
average <- dcast(extract_melt, subject + activity_name ~ variable, mean)
rm(extract_melt)