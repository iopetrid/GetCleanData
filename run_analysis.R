library(dplyr)
library(data.table)

# set directory
# setwd("/Users/iopetrid/Desktop/Coursera/Data Science/3_Getting and Cleaning Data/ProgrammingAssignment3/")
#---------------------------------------------------------------------------------
# 1. Merge training and test sets and create one  data set

training_data_X<-read.table("./UCI HAR Dataset/train/X_train.txt", sep= "", header = FALSE)
training_data_Y<-read.table("./UCI HAR Dataset/train/y_train.txt", sep= "", header = FALSE)

test_data_X<-read.table("./UCI HAR Dataset/test/X_test.txt", sep= "", header = FALSE)
test_data_Y<-read.table("./UCI HAR Dataset/test/y_test.txt", sep= "", header = FALSE)

training_data_Subject<-read.table("./UCI HAR Dataset/train/subject_train.txt", sep= "", header = FALSE)
test_data_Subject<-read.table("./UCI HAR Dataset/test/subject_test.txt", sep= "", header = FALSE)

  #bind data
data_X<-rbind(training_data_X,test_data_X)                   #dataset
data_Y<-rbind(training_data_Y,test_data_Y)                   #labels
data_subject<-rbind(training_data_Subject,test_data_Subject) #subjects

#---------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features<-read.table("./UCI HAR Dataset/features.txt", sep= "", header = FALSE) #read feature file
feature_selection<-grep("-mean\\(\\))|-std\\(\\)",features$V2) #get the mean and std
selected_X<-select(data_X,feature_selection) # create a subset with these mean and std
names(selected_X)<-features[feature_selection,2] #change the names of the derived dataset in order to be easily comprehensible

#---------------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set

activities<-read.table("./UCI HAR Dataset/activity_labels.txt", sep= "", header = FALSE) #read activities
data_Y$V1<-activities[data_Y[,1],2] #change the number to corresponding activity, e.g 1-walking, 2-laying
names(data_Y)<-"Activity"           #change the name from V1 to Activity

#---------------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.

names(data_subject)<-"Subjects"      #change the name from V1 to Subjects
final_data<-tbl_df(cbind(data_subject,data_Y,selected_X)) #combined dataset with Subjects X Activities X Values

#---------------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

almost_tidy<-group_by(final_data,Subjects,Activity) # first group by subject and activity
tidy_data<-summarise_all(almost_tidy,funs(mean))    # then calculate the mean and create the tidy data set

#write tidy_data to a txt file. use space as separator
write.table(tidy_data,"tidy_data.txt",sep=" ",row.name=FALSE)
 