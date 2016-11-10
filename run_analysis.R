library(reshape2)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features_names <- read.table("./UCI HAR Dataset/features.txt")[,2]

training_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
training_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")[,1]

# Use descriptive activity names to name the activities in the data set
training_activity <- activity_labels[training_labels[,1]]

testing_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
testing_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")[,1]

# Use descriptive activity names to name the activities in the data set
testing_activity <- activity_labels[testing_labels[,1]]

# Merge subject and activity vectors to corresponding data set.
training_data <- cbind(subject=subject_train, activity=training_activity, 
                       training_set)
testing_data <- cbind(subject=subject_test, activity=testing_activity, 
                      testing_set)

# Merge the training and the test sets to create one data set.
data <- rbind(training_data, testing_data)

# Appropriately label the data set with descriptive variable names. 
names(data)[3:563] <- as.character(features_names)

# Extract only the measurements on the mean and standard deviation for each 
# measurement. 
only_mean_std_sub_act <- grep("subject|activity|mean|std", colnames(data))
output_data <- data[,only_mean_std_sub_act]

# Create an independent tidy data set with the average of each variable 
# for each activity and each subject.
melt_data <- melt(output_data, id = c("subject", "activity"))
tidy_data <- dcast(melt_data, subject + activity ~ variable, mean)

write.table(tidy_data, file = "./tidy_dataset.txt", row.name=FALSE)