# download data
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  myFile <- 'data.zip'
  download.file(fileURL, myFile, method = "curl")

# unzip data
  unzip(myFile)

# get the path to data
  dataPath <- list.dirs()[2]

# list files
  list.files(path=dataPath, recursive=1)

# Read the train data
  X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read the test data
  X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#1. Merge the training and test data
  X <- rbind(X_train, X_test)
  y <- rbind(y_train, y_test)
  subject <- rbind(subject_train, subject_test)
  
#2. Extract only the measurements on the mean and standard deviation for each measurement

  # read feature names and activity labels
  features <- read.table("./UCI HAR Dataset/features.txt")
  activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

  # give columns their names
  colnames(X) <- features$V2
  
  # extract measurements on the mean and standard deviation
  X_mu_sd <- X[,grep("mean|std", colnames(X))]

#3. Use descriptive activity names to name the activities in the data set
  colnames(y) <- 'activityID'
  y['activityLabel'] <- as.character(activityLabels[y[,'activityID'], 'V2'])

#4. Appropriately label the data set with descriptive variable names
  # features and activities have been already named
  # label the subjects
  names(subject) = "subject"
  
  # bind everything together
  data <- cbind(subject, y['activityLabel'], X_mu_sd)
  
#5. From the data set in step 4, create a second, indpendent tidy data set
#   with the average of each variable for each activity and each subject
  
  # aggregate data to obtain tidyData
  tidyData <- aggregate(. ~subject + activityLabel, data, mean)
  tidyData <- tidyData[order(tidyData$subject,tidyData$activityLabel),]
  
  # write tidyData to disk
  write.table(tidyData, file = "tidyData.txt", row.name = FALSE)
  
  
  