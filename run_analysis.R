#load dplyr package
library(dplyr)

# Read test and train datasets and labels, subject identifiers, and activity labels into tables.

trainData<- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
testData <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE) 
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)




#bind the activity labels and the subject ids to the test and train data sets. The activity labels
#identify the activity the subject was performing during each observation.

test <- cbind(subjectTest, testLabels, testData)
train <- cbind(subjectTrain, trainLabels, trainData)

#The features.txt file contains the variable names for each observation. Read it in and label it 
#variableNames. Use gsub to clean up the variable names, deleting parentheses and dashes. Then
#convert all the variable names to lower case.



variableNames <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
noparens <- gsub("()", "", variableNames$V2, fixed = TRUE)
tidyLabels <- gsub("-", "", noparens, fixed = TRUE)


# append a label for the activity level column in the dataset to the tidyLabels vector.
tidyLabels <- c("subject", "activitylabel", tidyLabels)

#set the column names of the test and train datasets to the tidyLabels.
colnames(test) <- tidyLabels
colnames(train) <- tidyLabels


#merge the test and train data sets into a single data set.

data <- rbind(test, train)

#add a column that describes the activity for each observation.
activity <- data$activitylabel
activity <- factor(activity, labels = c("walking", "walkingupstairs", "walkingdownstairs",
                                        "sitting", "standing", "laying"))
data <- cbind(activity, data)


#select the columns that contain mean and standard deviation measurements.
data <- select(data, subject, activitylabel, activity, contains("mean"), contains("std"))

# group the data by activity and subject and find the average for each variable.
data <-  group_by(data, activity, subject)
averagedData <- summarise_each(data, funs(mean), contains("mean"), contains("std"))

