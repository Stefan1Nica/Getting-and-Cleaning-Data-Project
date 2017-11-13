library(reshape2)

# Loading the labels and the features
activityLabels <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])


#Subsetting the data only for the mean and the standard deviations
featuresWanted <- grep(".*mean.*|.*std.*", features[,2]) 
featuresWanted.names <- features[featuresWanted,2] 
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names) 
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names) 
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names) 


#Loading training set
train <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/train/X_train.txt")[featuresWanted] 
trainActivities <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/train/Y_train.txt") 
trainSubjects <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/train/subject_train.txt") 
train <- cbind(trainSubjects, trainActivities, train) 


#Loading testing sets
test <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/test/X_test.txt")[featuresWanted] 
testActivities <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/test/Y_test.txt") 
testSubjects <- read.table("C:/workspace/R training/Getting-and-Cleaning-Data-Project/UCI HAR Dataset/test/subject_test.txt") 
test <- cbind(testSubjects, testActivities, test) 


# Merging datasets and updating labels
allData <- rbind(train, test) 
colnames(allData) <- c("subject", "activity", featuresWanted.names) 


# Factorization
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2]) 
allData$subject <- as.factor(allData$subject) 


allData.melted <- melt(allData, id = c("subject", "activity")) 
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean) 

#Exporting
write.table(allData.mean, "C:/workspace/R training/Getting-and-Cleaning-Data-Project/tidy.txt", row.names = FALSE, quote = FALSE)


