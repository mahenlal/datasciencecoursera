
#Read training and test data into data frame

x_train<-read.table("train/X_train.txt", header = FALSE)
y_train<-read.table("train/y_train.txt" , header = FALSE)
subject_train<-read.table("train/subject_train.txt" , header = FALSE)

x_test<-read.table("test/X_test.txt", header = FALSE)
y_test<-read.table("test/y_test.txt" , header = FALSE)
subject_test<-read.table("test/subject_test.txt" , header = FALSE)

#Read features and activity label data

features<-read.table("features.txt", header = FALSE)
activity_labels<-read.table("activity_labels.txt" , header = FALSE)

#
#4. Appropriately labels the data set with descriptive variable names.
#
colnames(x_test)<-features[,2]
colnames(x_train)<-features[,2]
colnames(y_train)<-"Act_ID"
colnames(y_test)<-"Act_ID"
colnames(subject_test)<-"Subject_ID"
colnames(subject_train)<-"Subject_ID"
colnames(activity_labels)<-c('Act_ID', 'Act_Name')

# Merge Train Data colomns

TRAIN<- cbind(y_train, subject_train, x_train)

# Merge Test Data Columns

TEST <- cbind(y_test, subject_test, x_test)

#Combine TRAIN and TEST data rows
#1.Merges the training and the test sets to create one data set.

all_data<-rbind(TRAIN, TEST)


##2. Extracts only the measurements on the mean and standard deviation for each measurement.
colNames<-colnames(all_data)


#3.Uses descriptive activity names to name the activities in the data set

meanAndStdDev<-(grepl("Act_ID" , colNames) | grepl("Subject_ID" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

forMaenAndStdDev<-all_data[,meanAndStdDev==TRUE]

withActivity_name<-merge(forMaenAndStdDev, activity_labels, by = 'Act_ID', all.x=TRUE)


indTidyData<-aggregate(.~Subject_ID + Act_ID, withActivity_name, mean)
indTidyData<-indTidyData[order(indTidyData$Subject_ID, indTidyData$Act_ID),]

#Save data
write.table(indTidyData, "independentTidyData.txt", row.name=FALSE)

