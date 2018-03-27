# Assignment week 4: Getting and cleaning data

library(dplyr)
# Download the file and unzip files into working directory (already set)

Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url, destfile = "./SmartphoneSourceData.zip")
unzip("./SmartphoneSourceData.zip")

# Read in the features and activity labels information into seperate vectors to be used later in the script
features <- read.table("./UCI HAR Dataset/features.txt")


activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

colnames(activity) <- c("Act_ID", "Activity")
######################################################################################
#  Read in the training set data and associated reference files
Training_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
Test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
MergeData <- rbind(Training_set, Test_set)


Training_ActivityLabels<- read.table("./UCI HAR Dataset/train/y_train.txt")
Test_Activitylabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
MergeActivity <- rbind(Training_ActivityLabels, Test_Activitylabels)

Training_subjects <- read.table ("./UCI HAR Dataset/train/subject_train.txt")
Test_subjects <- read.table ("./UCI HAR Dataset/test/subject_test.txt")
MergeSubjects <- rbind(Training_subjects, Test_subjects)
########################################################################################



# adding appropriate name to the column
colnames(MergeData) <- features[,2]
colnames(MergeActivity) <- "Act_ID"
colnames(MergeSubjects) <- "Sub_ID"

# Combining all the dataset
Grand_merge <- cbind(MergeSubjects, MergeActivity, MergeData)

# getting the mearement related to mean and SD from the Grand_merged dataset.
Col_sel <- grepl("*mean\\(\\)|*std\\(\\)|Act_ID|Sub_ID", names(Grand_merge))
SelectedData <- Grand_merge[ , Col_sel]


Data_lab <- merge(SelectedData, activity, by="Act_ID") 
Data_lab <- Data_lab[, c(2,ncol(Data_lab), 3:(ncol(Data_lab)-1))]

# creating tidy dataset with mean of the variable.
TidyData <- aggregate(.~Sub_ID+Activity, Data_lab, mean)
TidyData <- arrange(TidyData, Sub_ID)

# txt file output on local drive
write.table(TidyData, "TidyData.txt", row.names = FALSE, quote = FALSE)