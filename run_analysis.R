#TAREA GETTING AND CLEANING DATA

#You should create one R script called run_analysis.R that does the following. 

library(tidyverse)

#1) Merges the training and the test sets to create one data set.
setwd("~/Ciencia de Datos/Coursera/Getting and cleaning data")

#training
sj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")  

#test
sj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")        

#merge
sj <- bind_rows(sj_train,sj_test)
x <- bind_rows(x_train,x_test)
y <- bind_rows(y_train,y_test)

rm("sj_test","sj_train","x_test","x_train","y_test","y_train")


#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
ft <- read.table("UCI HAR Dataset/features.txt")
nCols <- grep("-(mean|std).*", as.character(ft[,2]))
x <- x[nCols]
data <- bind_cols(sj,y,x)
Colnames <- ft[nCols, 2]
colnames(data) <- c("Subject", "Activity", Colnames)

#3) Uses descriptive activity names to name the activities in the data set
a_labs <- read.table("UCI HAR Dataset/activity_labels.txt")
data$Activity <- factor(data$Activity, levels = a_labs[,1], labels = a_labs[,2])
data$Subject <- as.factor(data$Subject)

#4) Appropriately labels the data set with descriptive variable names. 
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)

#5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_avg <- data %>% 
        group_by(Subject,Activity) %>% 
        summarise_all(mean)

write.table(data_avg, file = "tidydata.txt",row.name=FALSE)
