#downloda and unzip data
if(!file.exists("UCI HAR Dataset")){
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename<-("getdata_projectfiles_UCI HAR Dataset.zip")
download.file(fileURL, filename)
unzip(filename)
}

#1.Merges the training and the test sets to create one data set
Data_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
Data_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
Data<-rbind(Data_test, Data_train)

#4.Appropriately labels the data set with descriptive variable names.
Column<-read.table("./UCI HAR Dataset/features.txt")
colnames(Data)<-Column[,2]

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#Column<-read.table("./UCI HAR Dataset/features.txt")
colnumber<-grep("mean\\()|std\\()",Column[,2])
Extract_Data<-Data[,colnumber]

#3.Uses descriptive activity names to name the activities in the data set
row_test<-read.table("./UCI HAR Dataset/test/y_test.txt", col.names="Activity")
row_train<-read.table("./UCI HAR Dataset/train/y_train.txt",col.names="Activity")
ActivityNum<-rbind(row_test,row_train)
Data_Activity<-cbind(ActivityNum,Extract_Data)

#Match subject to the dataset
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names="Subject")
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names="Subject")
Subject_all<-rbind(test_subject,train_subject)
Data_sub_act<-cbind(Subject_all, Data_Activity)

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
subject<-unique(Data_sub_act$Subject)
result<-data.frame()
for(i in subject)
{
  Data_by_subject<-Data_sub_act[Data_sub_act$Subject==i,]
  activity<-unique(Data_by_subject$Activity)
  for(j in activity)
  {
    Data_by_activity<-Data_by_subject[Data_by_subject$Activity==j,]
    temp<-apply(Data_by_activity,2,mean)
    result<-rbind(result,temp)
  }
}
colnames(result)<-colnames(Data_sub_act)
result<-result[order(result$Subject,result$Activity),]
write.table(result,file="tidydata.pdf",row.names=FALSE)
