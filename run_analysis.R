
##The data
library(readr)
X_test <- read_table2("X_test.txt", col_names = FALSE)

##The activity code for the observations in the data (x_test)
y_test <- read_csv("y_test.txt", col_names = FALSE)


subject_test <- read_csv("subject_test.txt", col_names = FALSE)

##Headers for the data
features <- read_csv("features.txt", col_names = FALSE)

##Activity labels/descriptions which link to Training labels and Test Labels
activity_labels <- read_csv("activity_labels.txt", col_names = FALSE)



##cbind y_test to data so we have the activity code for each row
test<-cbind(y_test, X_test)

##Then add the subject identifier
test<-cbind(subject_test, test)

## Then set the names to activitycode for the column we binded and a vector created from the features tibble using pull for the other columns
library(dplyr)
names(test)<-c("subject","activitycode", pull(features,X1))

##Do the same for the train data set

X_train <- read_table2("X_train.txt", col_names = FALSE)
y_train <- read_csv("y_train.txt", col_names = FALSE)
subject_train <- read_csv("subject_train.txt", col_names = FALSE)
train<-cbind(y_train, X_train)
train<-cbind(subject_train, train)
names(train)<-c("subject", "activitycode", pull(features,X1))

##Combine the two
All<-rbind(test, train)

##Subset first two columns which we want to keep
keepcolumns<-All[,1:2]

##Subset to columns for mean and standard deviation
Allsmall<-All[, grepl("mean", names(All)) | grepl("std", names(All))]

##Lost the activity Code and subject Columns (keepcolumns), so we need to add them back
Allsmall<-cbind( keepcolumns, Allsmall)

##Bring in the Activity Labels
activity_labels <- read_table2("activity_labels.txt", col_names = FALSE)
names(activity_labels)<- c("code", "activity")

##Merge Activity Labels and the Allsmall data
Smallwithlabels<-merge(activity_labels, Allsmall, by.x="code", by.y="activitycode", all=TRUE)

##Arrange data by order and activity
Smallwithlabels<-arrange(Smallwithlabels, subject, code)


##CreateTidy Data with Averages
tidy<-group_by(Smallwithlabels, subject, code, activity)
tidy<-summarize_all(tidy,funs(mean)) 

##Add Avg to summarized columns
names(tidy)[4:82]<-paste0("avg", names(tidy)[4:82])


