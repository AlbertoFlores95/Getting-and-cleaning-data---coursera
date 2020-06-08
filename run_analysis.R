## Load dplyr library
install.packages("dplyr")
library(dplyr)

## Download and open files
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
wd <- getwd()
download.file(zipUrl, file.path(wd, "File.zip"))
unzip(file.path("File.zip"))

## Read Labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "", dec = ".")
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE, sep = "", dec = ".")
# Filter mean & std features
meanStdFeatures <- grep("mean|std", features$V2, value = TRUE)


## Read Test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "", dec = ".")
colnames(subject_test) <- "Subject"
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "", dec = ".")
colnames(x_test) <- features$V2
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "", dec = ".")
colnames(y_test) <- "Activity"
test <- cbind(subject_test, y_test, x_test)


## Read Train
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "", dec = ".")
colnames(subject_train) <- "Subject"
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "", dec = ".")
colnames(x_train) <- features$V2
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "", dec = ".")
colnames(y_train) <- "Activity"
train <- cbind(subject_train, y_train, x_train)


## Clean data set
dataSet <- rbind(test,train)
# Get only mean & Std columns
dataSet <- select(dataSet, Subject, Activity, meanStdFeatures)
# Change activity number for activity label
dataSet[["Activity"]] <- factor(dataSet[, "Activity"], levels = activity_labels[["V1"]], labels = activity_labels[["V2"]])
# Sort by Subject then Activity
dataSet <- arrange(dataSet, Subject, desc(Activity))

## Step 5 - mean of subject and activity
dataSet_mean <- dataSet %>% group_by(Subject, Activity) %>% summarise_all("mean")
# save on txt
data.table::fwrite(x = dataSet_mean, file = "final.txt", quote = FALSE)

