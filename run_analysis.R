# Read the zip file and un zip in local folder
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./UCI HAR Dataset.zip")){
        download.file(fileurl, "./UCI HAR Dataset.zip", mode="wb")
        unzip("./UCI HAR Dataset.zip", exdir =  getwd())
}

# Reading all Features Names
features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")
features <- as.character(features[,2])

# Reading all Data for tarining
data.training.x <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                              header = FALSE, sep = "")
data.training.activity <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                                     header = F)
data.training.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                                    header = F, sep = "")

# Combining Subject, activity and x in one data frame
data.training <- data.frame(data.training.subject, data.training.activity, 
                            data.training.x)
data.training <- setNames(data.training, c(c("subject","activity"), features))


# Reading all data for Test
data.test.x <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F, 
                          sep = "")
data.test.activity <- read.table("./UCI HAR Dataset/test/y_test.txt",
                                 header = F, sep = "")
data.test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                                header = F, sep = "")
# Combining Subject, activity and x in one data frame
data.test <- data.frame(data.test.subject, data.test.activity, data.test.x)
data.test <- setNames(data.test, c(c("subject", "activity"), features))

#Part 1 Merging Training and test data set together
data.all <- rbind(data.training, data.test)

# Part 2 Getting only Mean and Standard deviation columns
data.all.colnames <- colnames(data.all)
col_index <- grep("mean|std", data.all.colnames)

data.subset<- data.all[, c(1,2, col_index)]


#Part 3 To replace all the activity id with actual activity Name
data.activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F,
                            sep = "")
data.activity <- as.character(data.activity[,2])
data.subset$activity <- data.activity[data.subset$activity]

#Part 4- to rename the columns with porper value
data.names <- colnames(data.subset)
data.names <- gsub("^t", "TimeStamp-", data.names)
data.names <- gsub("^f", "Frequency-", data.names)
data.names <- gsub("mean", "Mean", data.names)
data.names <- gsub("std", "Standard Deviation", data.names)
data.names <- gsub("Mag", "Maginitude", data.names)
data.names <- gsub("Acc", "Accelerometer", data.names)
data.names <- gsub("Gyro", "Gyroscope", data.names)
data.names <- gsub("-", "_", data.names)
data.names <- gsub("[(][)]","", data.names)
names(data.subset) <- data.names


# Point 5
tidydata <- aggregate(data.subset[,3:81], by=list(activity = data.subset$activity,
                                                  subject = data.subset$subject),
                      FUN=mean)

write.table(tidydata, "data_tidy.txt", row.names = F)