## Getting and Cleaning Data Course Project
setwd("C:/Users/646347/Documents/Digital Intelligence/R/Coursera/Reading Cleansing Data/final")
ProjectDirectory = getwd()
DataDir = "UCI HAR Dataset/"
dataset = "dataset.RData"

## Get source data
fsource <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fdest <- "motiondat.zip"

download.file(fsource, fdest)
unzip("motiondat.zip")
file.remove("motiondat.zip")
setwd(DataDir)

#Variable descriptions
ftlabels <- read.table("features.txt", sep =  "", col.names = c("nbr", "desc"))
ftlabels <- ftlabels$desc
actlabels <- read.table("activity_labels.txt", sep =  "", col.names = c("nbr", "desc"))
actlabels <- as.character(actlabels$desc)

#create training dataset and applying variable names using labels from activity labels table
xtrain <- read.table("train/x_train.txt", sep = "")
names(xtrain) = ftlabels

##Activity table
ytrain <- read.table("train/y_train.txt", sep = "", col.names = c("activitytype"))
ytrain$activitytype = as.factor(ytrain$activitytype)
levels(ytrain$activitytype) = actlabels

##subject table
trainsubjects = read.table("train/subject_train.txt", sep = "", col.names = c("subject"))
trainsubjects$subject = as.factor(trainsubjects$subject)

##merge activities with subject to create training data
traindat = cbind(xtrain, trainsubjects, ytrain)

#create test datasets
xtest <- read.table("test/x_test.txt", sep = "")
names(xtest) = ftlabels

##combine activity and subjects
ytest <- read.table("test/y_test.txt", sep = "", col.names = c("activitytype"))
ytest$activitytype = as.factor(ytest$activitytype)
levels(ytest$activitytype) = actlabels

testsubjects = read.table("test/subject_test.txt", sep = "", col.names = c("subject"))
testsubjects$subject = as.factor(testsubjects$subject)

## Test data set by merging activity and subject
testdat = cbind(xtest, testsubjects, ytest)

#Merge training and test data
save(traindat, testdat, file = dataset)
alldat = rbind(traindat,testdat)

#Clean up unwanted files
rm(traindat, testdat, ytrain, ytest, xtrain, xtest, trainsubjects, testsubjects, 
   actlabels, ftlabels)

#2 Extract only the measurements on the mean and standard deviation for each measurement
std_col <- alldat[grep("std()",names(alldat))]
mean_col <- alldat[grep("mean()",names(alldat))]
subdat <- cbind(alldat$subject, alldat$activitytype ,std_col, mean_col)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

average_by_act <- aggregate(subdat[, 3:81], list(subdat$`alldat$activitytype`, subdat$`alldat$subject`), mean)
write.table(average_by_act, file = "average_by_act.txt", row.names = FALSE)
