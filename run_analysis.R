## Set the working directory
setwd("/Users/Admin/Google Drive/coursera/Getting and Cleaning Data")
## Download the data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
## unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")
## Get the list of files
path_rf <- file.path("./data" , "UCI HAR Dataset")
## Read test and train data and merge
dataXTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataXTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
dataX<- rbind(dataXTrain, dataXTest)
##
dataYTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataYTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
dataY<- rbind(dataYTrain, dataYTest)
##
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
##
## set names to variables
dataXNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataX)<- dataXNames$V2
names(dataY)<- c("activity")
names(dataSubject)<-c("subject")
##
dataCombine <- cbind(dataSubject, dataY)
Data <- cbind(dataX, dataCombine)
##
## Extracting only the measurements on the mean and standard deviation for each measurement
subdataXNames<-dataXNames$V2[grep("mean\\(\\)|std\\(\\)", dataXNames$V2)]
selectedNames<-c(as.character(subdataXNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
## Using descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
Data$activity<-factor(Data$activity);
Data$activity<- factor(Data$activity,labels=as.character(activityLabels$V2))
## Label the data set with descriptive variable names
## prefix t is replaced by time
## Acc is replaced by Accelerometer
## Gyro is replaced by Gyroscope
## prefix f is replaced by frequency
## Mag is replaced by Magnitude
## BodyBody is replaced by Body
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)
## Creating a second,independent tidy data set and ouputing it
library(plyr);
TidyData<-aggregate(. ~subject + activity, Data, mean)
TidyData<-TidyData[order(TidyData$subject,TidyData$activity),]
write.table(TidyData, file = "TidyData.txt",row.name=FALSE)
##
