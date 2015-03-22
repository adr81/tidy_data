## This Readme file details the workings of the run_analysis.R script. This script carries out the following instructions:

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## The script requires the packages dplyr & reshape2.


## Part 1 - Loading the data


## The first section loads the different data sets from the UCI HAR folder and stores them as the following dataframes:

activity_labels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))
## 'activity_labels.txt': Links the class labels with their activity name.

features <- tbl_df(read.table("./UCI HAR Dataset/features.txt"))
## 'features.txt': List of all feature labels.

subject_test <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt"))
## 'subject_test.txt': List of the participating subjects in the test data set.

test_set <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))
## 'x_test.txt': The test data set.

test_labels <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt"))
## 'y_test.txt': The test data set activity labels.

subject_train <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt"))
## 'subject_train.txt': List of the participating subjects in the training data set.

train_set <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))
## 'x_train.txt': The training data set.

train_labels <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt"))
## 'y_train.txt': The training data set activity labels.


## Part 2 - Merging the data


## The following section combines the test and training data sets into one data frame thus achieving the first requirement of this project:

l_test_set <- tbl_df(cbind(test_labels, subject_test, test_set))
## Adds the activity labels and participating subjects to the test data set.

l_train_set <- tbl_df(cbind(train_labels, subject_train, train_set))
## Adds the activity labels and participating subjects to the training data set.

rm(test_labels, subject_test, test_set, train_labels, subject_train, train_set)
## Removes the old data sets as well as the activity and subject labels to keep the global environment tidy.

feature_names <- make.names(features[, 2], unique = TRUE)
colnames(l_test_set) <- c("activity", "subject", feature_names)
colnames(l_train_set) <- c("activity", "subject", feature_names)
## Renames the variables using the features data frame.

combined <- rbind(l_test_set, l_train_set)
rm(l_test_set, l_train_set)
## Combines the test and training data sets and removes the old data frames.


## Part 3 - Extracting the mean and standard deviation variables and adding descriptive activity names to the activities in the data set thus achieving the second & third requirements of this project:


extract <- select(combined, activity, subject, contains("Mean"), contains("std"))
## Extracts only the measurements on the mean and standard deviation for each measurement.

extract <- merge(extract, activity_labels, by.x = "activity", by.y = "V1")
extract <- rename(extract, activity_name = V2)
## Adds a variable of descriptive activity names to name the activities in the data set.


## Part 4 - Appropriately labels the data set with descriptive variable names. 


## I feel that the variable labels already used in the dataset meet the requirements of the fourth part of this project so I have left them as they are. Please see the CodeBook.txt file for further details on the dataset, including a description of the variable names (this is a combination of the README.txt & features_into.txt files that came as part of the UCI HAR Dataset).


## Part 5 - Uses reshape2 to melt the extract data frame and dcast back into the mean for each variable by subject and activity thus meeting the fifth requirment of this project:

variables <- colnames(extract)
extract_melt <- melt(extract, id = c("subject", "activity_name"), measure.vars = variables[-c(1, 2, 89)])
average <- dcast(extract_melt, subject + activity_name ~ variable, mean)
## Creates a data frame called average which has the mean of each variable in the columns and the subject & activities in each row.