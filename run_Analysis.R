##get to the directory where the data set is saved
setwd("./UCI HAR Dataset")

## create the dataframe that stores the names of the activities and the variables
VarNames <- read.table("features.txt")
VarNames <- VarNames$V2
head(VarNames)
ActNames <- read.table("activity_labels.txt")
head(ActNames)
ActNames <- ActNames$V2


##Read the training and test set, and descriptively name the variables and the corresponding actvities for each row. 
setwd("./test")
x_test <- read.table("x_test.txt")
colnames(x_test) <- VarNames
y_test_temp <- read.table("y_test.txt")
y_test <- y_test_temp
colnames(y_test) <- c("activityType")
class(y_test$activityType) <- c("character")
for (i in 1:nrow(y_test)) {y_test$activityType[i] <- as.character(ActNames[y_test_temp$V1[i]])}
testset <- cbind(y_test, x_test)
setwd("..")
setwd("./train")
x_train <- read.table("x_train.txt")
colnames(x_train) <- VarNames
colnames(x_test) <- VarNames
y_train_temp <- read.table("y_train.txt")
y_train <- y_train_temp
colnames(y_train) <- c("activityType")
class(y_train$activityType) <- c("character")
for (i in 1:nrow(y_train)) {y_train$activityType[i] <- as.character(ActNames[y_train_temp$V1[i]])}
trainset <- cbind(y_train, x_train)


## merge the training and test set, and extract the measurment that are related to mean and standard derivation. 
mergeData <- rbind(trainset, testset)
mergeDataMeanStd <- mergeData[, grepl("*mean|std", colnames(mergeData))]
mergeDataMeanStd <- cbind(mergeData$activityType, mergeDataMeanStd)
colnames(mergeDataMeanStd)[1] <- c("activityType")
setwd("..")
write.table(mergeDataMeanStd, file="mergeDataMeanStd.txt",row.names=FALSE)
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
## read the data set to check if the data is properly saved.
head(read.table("meanOfActivity.txt",header=TRUE))