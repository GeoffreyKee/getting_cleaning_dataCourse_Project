## R Script name : run_analysis.R
setwd("D:/Coursera/getting_cleaning_dataCourse_Project/getting_cleaning_dataCourse_Project")
# To call relevant library
library(data.table)
library(reshape2)
library(dplyr)

# load the  X and Y test table
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE)

# setting X and Y train table
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE)

# Load: activity labels + Features
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
act_labels[,2] <- as.character(act_Labels[,2])
measurement_features <- read.table("./UCI HAR Dataset/features.txt")
measurement_features[,2] <- as.character(measurement_features[,2])
measurement_features
features <- grep(".*mean.*|.*std.*", measurement_features[,2])
features.names <- measurement_features[features,2]
features.names = gsub('-mean', 'Mean', features.names)
features.names = gsub('-std', 'Std', features.names)
features.names <- gsub('[-()]', '', features.names)
features.names

# Bind data
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)
subject_dataset = rbind(test_data, train_data)
colnames(subject_dataset) <- c("subject", "activity", features.names)

#factoring 
subject_dataset$activity <- factor(subject_dataset$activity, levels = act_labels[,1],labels = act_labels[,2])
subject_dataset$subject <- as.factor(subject_dataset$subject)
melt_data <- melt(subject_dataset, id = c("subject","activity"))
mean_data <- dcast(melt_data, subject + activity ~ variable, mean)
#write
write.table(mean_data, "tidy.txt", row.names = FALSE, quote = FALSE)






