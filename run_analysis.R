
## Set the work repertory and useful variables
setwd(dir = "X:/Kershin/DOCUMENTS 2015/Archives/Data_Science/GettingAndCleaningData_LastExam")
Data_Rep <- "UCI HAR Dataset"
ALL_data_train_files <- c('X_train.txt','y_train.txt','subject_train.txt','Inertial Signals/total_acc_x_train.txt','Inertial Signals/body_acc_x_train.txt','Inertial Signals/body_gyro_x_train.txt')
ALL_data_test_files <- c('X_test.txt','y_test.txt','subject_test.txt','Inertial Signals/total_acc_x_test.txt','Inertial Signals/body_acc_x_test.txt','Inertial Signals/body_gyro_x_test.txt')

## Generate the url to use to read files afterwards
ALL_url_data_train_files <- lapply(ALL_data_train_files,function(x) paste(paste(Data_Rep,"/train/",sep = ""),x,sep = ""))
ALL_url_data_test_files <- lapply(ALL_data_test_files,function(x) paste(paste(Data_Rep,"/test/",sep = ""),x,sep = ""))

## Get test/train files content in files
df_train <- lapply(ALL_url_data_train_files,read.table)
df_test <- lapply(ALL_url_data_test_files,read.table)

## Merges the training and the test sets to create one data set
df_data <- rbind(df_train[[1]],df_test[[1]])

## Get the features and put it as col names 
list_features = read.table(paste(Data_Rep,"/features.txt",sep = ""))
names(df_data) <- list_features[[2]]

## Get and add labels as a new column
list_activity_labels = read.table(paste(Data_Rep,"/activity_labels.txt",sep = ""))
df_labels <- rbind(df_train[[2]],df_test[[2]]) 
library(dplyr)
df_labels_names <- mutate(.data = df_labels,labels = list_activity_labels$V2[V1])
df_data_labeled <- cbind(df_data,df_labels_names)

## Get and add subjects as a new column
df_subjects <- rbind(df_train[[3]],df_test[[3]]) 
names(df_subjects) <- "subjects"
df_data_complete <- cbind(df_data_labeled,subjects = df_subjects)

## Select only the mean() and std()
df_data_selection <- df_data_complete[,grep(pattern = paste(c('-mean\\(\\)-','-std\\(\\)-','labels','subjects'),collapse="|"),x = names(df_data_complete))]

## Calculate the mean value for each variables, grouped by activities and subjects
df_data_tiny <- aggregate(. ~ subjects+labels, df_data_selection, mean)

## Loading the result in upload.txt file
write.table(x = df_data_tiny, file = "upload.txt",row.name=FALSE)