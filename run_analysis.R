# Getting and Cleaning Data Course Project


# Load features
Features <- read.table("features.txt")
Features[,2] <- as.character(Features[,2])

# Load activity labels
Act_Labels <- read.table("activity_labels.txt")
Act_Labels[,2] <- as.character(Act_Labels[,2])

# Extract from features only data related with mean and standard deviation
FeaturesSelect <- grep(".*mean.*|.*std.*", Features[,2])
FeaturesSelect.names <- Features[FeaturesSelect,2]
FeaturesSelect.names = gsub('-mean', 'Mean', FeaturesSelect.names)
FeaturesSelect.names = gsub('-std', 'Std', FeaturesSelect.names)
FeaturesSelect.names <- gsub('[-()]', '', FeaturesSelect.names)


# Load DataSets
Subject_Train <- read.table("train/subject_train.txt")
X_Train <- read.table("train/X_train.txt")[FeaturesSelect]
Y_Train <- read.table("train/Y_train.txt")
Train <- cbind(Subject_Train, Y_Train, X_Train)

Subject_Test <- read.table("test/subject_test.txt")
X_Test <- read.table("test/X_test.txt")[FeaturesSelect]
Y_Test <- read.table("test/Y_test.txt")
Test <- cbind(Subject_Test, Y_Test, X_Test)

# Merge Datasets and add labels
Data <- rbind(Train, Test)
colnames(Data) <- c("subject", "activity", FeaturesSelect.names)


# Turn Activities & Subjects
Data$activity <- factor(Data$activity, levels = Act_Labels[,1], labels = Act_Labels[,2])
Data$subject <- as.factor(Data$subject)

library(reshape2)
Data.melt <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melt, subject + activity ~ variable, mean)

write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
