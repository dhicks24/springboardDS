---
title: "CodeBook"
output: html_document
---

## Project Summary

This project called for analysis and transformation of data collected as part of experiments in human activity recognition using the Samsung Galaxy S II smartphone's embedded accelerometer and gyroscope. The data was presented across multiple data sets, and the objectives for Data Wrangling Exercise 3 included:
  
  1) Merge the training and test data sets into one data set
  2) Extract columns containing mean and standard deviation for each measurement
  3) Create variables for ActivityLabel and ActivityName that label all observations appropriately
  4) Create an independent tidy data set with the average of each variable for each activity and each subject


## Provided Data

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws


## Variables & Uses

The following variables were used in completion of the data analysis and transformations:

- sub_id <- "Subject_ID"  # variable to represent the subject number (1-30); used to join the Test and Train sets, used as a group_by in final tidy set

- act_num <- "ActivityLabel"  # variable to represent the activity number (1-6); used to join combined test/train data to activity labels/names, used as a group_by in final tidy set

- feat_name <- features$V2  # variable to represent the list of "features" (measurements); used to convert column names from vague V1:V100 to explicit names

- features <- read.table(file = "features.txt")  # variable to represent the features data set; used to enable the "feat_name" variable



## Data Transformations

The following transformations were used in completion of the project:

0. Load source data sets

- sub_test <- read.table(file = "subject_test.txt", col.names = sub_id)  # load and transform subject_test file to specify the "sub_id" column name

- testSet <- read.table(file = "X_test.txt", col.names = feat_name)  # load and transform X_test file to specify the "feat_name" column name

- testLabels <- read.table(file = "Y_test.txt", col.names = act_num)  # load and transform y_test file to specify the "act_name" column name


- sub_train <- read.table(file = "subject_train.txt", col.names = sub_id)  # load and transform subject_train file to specify the "sub_id" column name

- trainSet <- read.table(file = "X_train.txt", col.names = feat_name)  # load and transform X_train file to specify the "feat_name" column name

- trainLabels <- read.table(file = "Y_train.txt", col.names = act_num)  # load and transform y_test file to specify the "act_name" column name


1. Merge test and training data into one data set

- testAll <- cbind(sub_test, testLabels, testSet)  # transform subject, features, and activity label files into combined test ds; used to join the Test and Train sets

- trainAll <- cbind(sub_train, trainLabels, trainSet)  # transform subject, features, and activity label files into combined train ds; used to join the Test and Train sets

- combDS <- rbind(testAll, trainAll)  # transform combined test set & combined train sets into fully combined ds; used to extract mean & std variables in next step


2. Extract columns containing mean and stdDev for each measurement

- mean_std_extract <- select(combDS, contains("Subject_ID"), contains("ActivityLabel"), contains("mean"), contains("std"))  # transform to extract of mean & std columns


3. Create ActivityLabel and ActivityName variables for each observation

- actLabels <- read.table(file = "activity_labels.txt", col.names = c("ActivityLabel", "ActivityName"))  # transform activity_labels file to specify ActivityLabel and ActivityName columns 

- mean_std_extract <- merge(mean_std_extract, actLabels, by = "ActivityLabel")  # transforms mean_std_extract and actLabels into single table (merged by ActivityLabel key)

- mean_std_extract <- subset(mean_std_extract, select=c(1, 89, 3, 2, 4:88))  # transform table to reorder columns (putting ActivityLable and ActivityName at front)


4. Create an independent tidy data set with the average of each variable for each activity and each subject

- tidy_set <- mean_std_extract %>% group_by(Subject_ID, ActivityLabel, ActivityName) %>% summarise_each(funs(mean), 4:89)  # transform to tidy set of feature means grouped by Activity & Subject


5. Generate the tidy data set (in csv)

- write.csv(tidy_set,"tidy_set.csv")  #  saves tidy data set as csv file 


## Summary of Referenced Study
  
Human Activity Recognition Using Smartphones Dataset
Version 1.0

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

