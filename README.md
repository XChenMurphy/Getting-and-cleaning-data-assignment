# get to the directory where all the dataset is
setwd("./projects/Getting and cleaning data/UCI HAR Dataset")

# read the text file features.txt and activity_labels.txt, which gives the names of the columns of the dataset
VarNames <- read.table("features.txt")
VarNames <- VarNames$V2
head(VarNames)
ActNames <- read.table("activity_labels.txt")
head(ActNames)
ActNames <- ActNames$V2



## get to the directory where test dataset is
setwd("./test")

## read the test dataset
x_test <- read.table("x_test.txt")

## name the activities in the test data set with descriptive activity names 
colnames(x_test) <- VarNames

## read the corresponding activities for the test set and name it with the corronponding activities names
y_test_temp <- read.table("y_test.txt")
y_test <- y_test_temp
colnames(y_test) <- c("activityType")
class(y_test$activityType) <- c("character")
for (i in 1:nrow(y_test)) {y_test$activityType[i] <- as.character(ActNames[y_test_temp$V1[i]])}

## create the data testset with descriptive activity names and variables
testset <- cbind(y_test, x_test)


setwd("..")
## Apply the similar code to save the training set with descriptive activity names and variable names. 
setwd("./train")

## read the training data set
x_train <- read.table("x_train.txt")

## name the activites in the training data set with descriptivie activity names.
colnames(x_train) <- VarNames

## name the activities in the test data set with descriptive activity names 
colnames(x_test) <- VarNames

## read the corresponding activities for the test set and name it with the corronponding activities names
y_train_temp <- read.table("y_train.txt")
y_train <- y_train_temp
colnames(y_train) <- c("activityType")
class(y_train$activityType) <- c("character")
for (i in 1:nrow(y_train)) {y_train$activityType[i] <- as.character(ActNames[y_train_temp$V1[i]])}

## create the data testset with descriptive activity names and variables
trainset <- cbind(y_train, x_train)


## merge the training and the test sets together
mergeData <- rbind(trainset, testset)

## Extract the measurements on the mean and standard deviataion for each measurement.
mergeDataMeanStd <- mergeData[, grepl("*mean|std", colnames(mergeData))]

## add the column of corresponding activity type for each row
mergeDataMeanStd <- cbind(mergeData$activityType, mergeDataMeanStd)
colnames(mergeDataMeanStd)[1] <- c("activityType")

## save the data frame meargeDataMeanStd in the file called mergeDataMeanStd.txt
setwd("..")
write.table(mergeDataMeanStd, file="mergeDataMeanStd.txt",row.names=FALSE)

## read the data set to check that the data is properly saved.
head(read.table("mergeDataMeanStd.txt",header=TRUE))


## create an independentt dataset with the average of each variable for each activity and each subject.
meanOfActivity <- data.frame(matrix(NA, nrow=length(ActNames), ncol=ncol(mergeDataMeanStd)))
meanOfActivity[,1] <- names(sapply(split(mergeDataMeanStd[,2],mergeDataMeanStd$activityType),mean))
colnames(meanOfActivity)[1] <- c("activityType")
for (i in 2:ncol(meanOfActivity)){
	colnames(meanOfActivity)[i] <- colnames(mergeDataMeanStd)[i]
	meanOfActivity[,i] <- sapply(split(mergeDataMeanStd[,i],mergeDataMeanStd$activityType),mean)}
	
## save the data frame mergeDataColMeans in a file called mergeDataColMeans.txt.
write.table(meanOfActivity, file="meanOfActivity.txt",row.names=FALSE)

## read the data set to check that the data is properly saved.
head(read.table("meanOfActivity.txt",header=TRUE))
