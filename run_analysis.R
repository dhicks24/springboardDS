# 0. Environment setup & data loads

library(dplyr)  # enable the dplyr library
library(tidyr)  # enable the tidyr library
library(knitr)  # enable the knitr librarr

sub_id <- "Subject_ID"  # variable to represent the subject number (1-30); used to join the Test and Train sets, used as a group_by in final tidy set

act_num <- "ActivityLabel"  # variable to represent the activity number (1-6); used to join combined test/train data to activity labels/names, used as a group_by in final tidy set

feat_name <- features$V2  # variable to represent the list of "features" (measurements); used to convert column names from vague V1:V100 to explicit names

features <- read.table(file = "features.txt")  # variable to represent the features data set; used to enable the "feat_name" variable


sub_test <- read.table(file = "subject_test.txt", col.names = sub_id)  # load and transform subject_test file to specify the "sub_id" column name

testSet <- read.table(file = "X_test.txt", col.names = feat_name)  # load and transform X_test file to specify the "feat_name" column name

testLabels <- read.table(file = "Y_test.txt", col.names = act_num)  # load and transform y_test file to specify the "act_name" column name


sub_train <- read.table(file = "subject_train.txt", col.names = sub_id)  # load and transform subject_train file to specify the "sub_id" column name

trainSet <- read.table(file = "X_train.txt", col.names = feat_name)  # load and transform X_train file to specify the "feat_name" column name

trainLabels <- read.table(file = "Y_train.txt", col.names = act_num)  # load and transform y_test file to specify the "act_name" column name




# 1. Merge test and training data into one data set

testAll <- cbind(sub_test, testLabels, testSet)  # transform subject, features, and activity label files into combined test ds; used to join the Test and Train sets

trainAll <- cbind(sub_train, trainLabels, trainSet)  # transform subject, features, and activity label files into combined train ds; used to join the Test and Train sets

combDS <- rbind(testAll, trainAll)  # transform combined test set & combined train sets into fully combined ds; used to extract mean & std variables in next step


# 2. Extract columns containing mean and stdDev for each measurement

mean_std_extract <- select(combDS, contains("Subject_ID"), contains("ActivityLabel"), contains("mean"), contains("std"))  # transform to extract of mean & std columns


# 3. Create ActivityLabel and ActivityName variables for each observation

actLabels <- read.table(file = "activity_labels.txt", col.names = c("ActivityLabel", "ActivityName"))  # transform activity_labels file to specify ActivityLabel and ActivityName columns 

mean_std_extract <- merge(mean_std_extract, actLabels, by = "ActivityLabel")  # transforms mean_std_extract and actLabels into single table (merged by ActivityLabel key)

mean_std_extract <- subset(mean_std_extract, select=c(1, 89, 3, 2, 4:88))  # transform table to reorder columns (putting ActivityLable and ActivityName at front)


# 4. Create an independent tidy data set with the average of each variable for each activity and each subject

tidy_set <- mean_std_extract %>% group_by(Subject_ID, ActivityLabel, ActivityName) %>% summarise_each(funs(mean), 4:89)  # transform to tidy set of feature means grouped by Activity & Subject


# 5. Generate the tidy data set (in csv)

write.csv(tidy_set,"tidy_set.csv")  #  saves tidy data set as csv file 
