
#STEP- 1 MERGING THE DATA

# create the data directory

if (!file.exists("data")){
        dir.create("./data")
}
# Download,unzip and list files of the data

fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile = "./data/project.zip")
datazip<-"./data/project.zip"
unzip(datazip)
setwd("./data/UCI HAR Dataset")
list.files("./")
# Build data train
  ## load labels activity labels and features
  activitylabels<-read.table("./activity_labels.txt",quote = "", sep = "",row.names = 1)
  features<-read.table("./features.txt", row.names=NULL,header =FALSE, col.names= c("integer","feature"), colClasses = c("NULL","character"), quote = "", sep = "")
  ## create features as a vector column names
  trasfeatures<- t(features)
  ## bind subject, Y_train and X_train
  labelstrain<- read.table("./train/Y_train.txt", col.names ="activiy", quote = "", sep = "")
  datatrain<- read.table("./train/X_train.txt",header = FALSE, col.names = trasfeatures, quote = "",sep = "")
  subjecttrain<- read.table("./train/subject_train.txt", col.names = "subject",quote = "", sep = "")
  train1<- cbind(labelstrain,subjecttrain,datatrain)
  ## nest train inertial signals
    ### create list files for loop
    filestr<- list.files("./train/Inertial Signals", full.names = TRUE)
    files_nametr<- list.files("./train/Inertial Signals", full.names = FALSE)
    ###create a vector of column names
    library(stringr)
    name_filetr1<-as.name(files_nametr[1])
    str_sub(name_filetr1,-10,-1)<- ""
    namestr1<- rep(as.character(name_filetr1),128)
    varseqtr1<-seq(1:128)
    varnamestr1<- paste(namestr1,varseqtr1,sep = "")
    ### load the first file
    Inertial_train<- read.table(filestr[1], quote= "",col.names = varnamestr1, sep = "")
    ### nested the rest files
    for (i in 2:length(filestr)){
        name_filetr<-as.name(files_nametr[i])
        str_sub(name_filetr,-10,-1)<- ""
        namestr<- rep(as.character(name_filetr),128)
        varseqtr<-seq(1:128)
        varnamestr<- paste(namestr,varseqtr,sep = "")
        Inertial_train<- cbind(Inertial_train,read.table(filestr[i], quote= "", col.names= varnamestr,sep = ""))
    }
    dim(Inertial_train)
    head(names(Inertial_train),1152)
  ## bind train1 with Train inertial signals
  Traincomplete<- cbind(train1,Inertial_train)

# CREATE COMPLETE DATA TEST

  ## load labels activity labels and features
  activitylabels<-read.table("./activity_labels.txt",quote = "", sep = "",row.names = 1)
  features<-read.table("./features.txt", row.names=NULL,header =FALSE, col.names= c("integer","feature"), colClasses = c("NULL","character"), quote = "", sep = "")
  ## create features as a vector column names
  trasfeatures<- t(features)
  ## bind with subject, labels and data test
  labelstest<- read.table("./test/Y_test.txt", col.names ="activiy", quote = "", sep = "")
  datatest<- read.table("./test/X_test.txt",header = FALSE, col.names = trasfeatures, quote = "",sep = "")
  subjecttest<- read.table("./test/subject_test.txt", col.names = "subject",quote = "", sep = "")
  test1<- cbind(labelstest,subjecttest,datatest)
  ## nest inertial signals
    ### create list files for loop
    fileste<- list.files("./test/Inertial Signals", full.names = TRUE)
    files_namete<- list.files("./test/Inertial Signals", full.names = FALSE)
    ###create a vector of column names  
    library(stringr)
    name_filete1<-as.name(files_namete[1])
    str_sub(name_filete1,-9,-1)<- ""
    nameste1<- rep(as.character(name_filete1),128)
    varseqte1<-seq(1:128)
    varnameste1<- paste(nameste1,varseqte1,sep = "")
    ### load the first file
    Inertial_test<- read.table(fileste[1], quote= "",col.names = varnameste1, sep = "")
    ### nested the rest files
    for (i in 2:length(fileste)){
        name_filete<-as.name(files_namete[i])
        str_sub(name_filete,-9,-1)<- ""
        nameste<- rep(as.character(name_filete),128)
        varseqte<-seq(1:128)
        varnameste<- paste(nameste,varseqte,sep = "")
        Inertial_test<- cbind(Inertial_test,read.table(fileste[i], quote= "", col.names= varnameste,sep = ""))
}
  ## nest test1 with inertial signals
  testcomplete<- cbind(test1,Inertial_test)
  
# MERGE DATA TABLE WITH DATA TRAIN
  
  library(dplyr)
  ## create type variable test and train
  type= rep ("Train",nrow(Traincomplete))
  Traincomplete<- cbind(type,Traincomplete)
  type= rep ("Test",nrow(testcomplete))
  testcomplete <- cbind(type,testcomplete)
  ## check subject field in each table
  table(Traincomplete$subject)
  table(testcomplete$subject)
  ## merge the train and test table
  datacomplete<-merge(Traincomplete,testcomplete, all = TRUE)

  # EXTRACT THE MEAN FOR EACH MEASSUREMENTS
  library(dplyr)
  library(stringr)
  library(data.table)
  library(gsubfn)
  ## grep the names of the variables in order to select mean meassurements
  datamean<- datacomplete[grep("mean", names(datacomplete), ignore.case = TRUE)]
  names<-data.table(names(datamean))
  ## create the column mean
  colmean<-colMeans(datamean)
  DF_mean<-cbind(names,data.table(colmean))
  meassurements<- c("tBodyAcc","tGravityAcc","tBodyAccJerk","tBodyGyro","tBodyGyroJerk","tBodyAccMag","tGravityAccMag","tBodyAccJerkMag",
                    "tBodyGyroMag","tBodyGyroJerkMag","fBodyAcc","fBodyAccJerk","fBodyGyro","fBodyAccMag","fBodyAccJerkMag","fBodyGyroMag",
                    "fBodyGyroJerkMag")
  X<- row.names(DF_mean) %in% grep("X",DF_mean$V1)
  Y<- row.names(DF_mean) %in% grep("Y",DF_mean$V1)         
  Z<- row.names(DF_mean) %in% grep("Z",DF_mean$V1)
  DF_mean2<-cbind(DF_mean,X,Y,Z)
  DF_mean3<-head(DF_mean2,46)
  DF_mean4<-DF_mean3
  DF_mean4$V1<-c("tBodAcc","tBodAcc","tBodAcc","tGravitAcc","tGravitAcc","tGravitAcc","tBodAccJerk","tBodAccJerk","tBodAccJerk","tBodGro","tBodGro",
                 "tBodGro","tBodGroJerk","tBodGroJerk","tBodGroJerk","tBodAccMag","tGravitAccMag","tBodAccJerkMag","tBodGroMag","tBodGroJerkMag","fBodAcc",
                 "fBodAcc","fBodAcc","fBodAccFreq","fBodAccFreq","fBodAccFreq","fBodAccJerk","fBodAccJerk","fBodAccJerk","fBodAccJerkFreq","fBodAccJerkFreq",
                 "fBodAccJerkFreq","fBodGro","fBodGro","fBodGro","fBodGroFreq","fBodGroFreq","fBodGroFreq","fBodAccMag","fBodAccMagFreq","fBodBodAccJerkMag",
                 "fBodBodAccJerkMagFreq","fBodBodGroMag","fBodBodGroMagFreq","fBodBodGroJerkMag","fBodBodGroJerkMagFreq")
  factor<-group_by(DF_mean4, as.factor(DF_mean4$V1))
  mean_final<- summarize(factor,mean = mean(colmean))
  mean_final
  # EXTRACT THE DESVIACION STANDAR FOR EACH MEASSUREMENTS
  library(dplyr)
  library(stringr)
  library(data.table)
  library(gsubfn)
  ## grep the names of the variables in order to select mean meassurements
  datastd<- datacomplete[grep("std", names(datacomplete), ignore.case = TRUE)]
  names<-data.table(names(datastd))
  ## create the std for each column
  colmean<-colMeans(datastd)
  ## select names and average of the std
  DF_std<-cbind(names,data.table(colmean))
  DF_std2<-DF_std
  DF_std2$V1<-c("tBodAcc","tBodAcc","tBodAcc","tGravitAcc","tGravitAcc","tGravitAcc","tBodAccJerk","tBodAccJerk","tBodAccJerk","tBodGro","tBodGro",
                 "tBodGro","tBodGroJerk","tBodGroJerk","tBodGroJerk","tBodAccMag","tGravitAccMag","tBodAccJerkMag","tBodGroMag","tBodGroJerkMag","fBodAcc",
                 "fBodAcc","fBodAcc","fBodAccJerk","fBodAccJerk","fBodAccJerk","fBodGro","fBodGro","fBodGro","fBodAccMag","fBodBodAccJerkMag",
                 "fBodBodGroMag","fBodBodGroJerkMag")
  factor<-group_by(DF_std2, as.factor(DF_std2$V1))
  std_final<- summarize(factor,mean = mean(colmean))
  std_final
  
# CREATE DESCRIPTIVE NAMES
  save(datacomplete, file="datacomplete.rda")
  load("datacomplete.rda")
  library(stringr)
  library(dplyr)
  ## retrieve names
  names<-colnames(datacomplete)
  ## divide vector names
  names0<- names[1:3]
  names1<-names[4:565]
  names2<- names[566:length(names)]
  ##change names vector names1 
    ### chang3e "t" by time
    for (i in 1:265){str_sub(names1[i],1,1)<-"time"} 
    ### chang3e "f" by freq
    for (i in 266:554){str_sub(names1[i],1,1)<-"freq"} 
    ### changte "Acc" by Accelerometer
    for (i in grep("Acc",names1,ignore.case = FALSE)){str_sub(names1[i],9,11)<-"Accelerometer"} 
    ### changte "Gyro" by Gyroscope
    for (i in grep("Gyro",names1,ignore.case = FALSE)){str_sub(names1[i],13,16)<-"Gyroscope"} 
  ## concatenate vector names
  new_names<- c(names0,names1,names2)
  colnames(datacomplete)<- new_names
  names(datacomplete)

#CREATE FACTOR - POINT 4

    library(dplyr)
  ## check variable type
  is.factor(datacomplete$type)
  table(datacomplete$type)
  ## define variable activity as factor
  is.factor(datacomplete$activiy)
  activitylabels<-read.table("./activity_labels.txt",quote = "", sep = "",row.names = 1)
  datacomplete$activiy<-factor(datacomplete$activiy,levels=c(1:6), labels=activitylabels$V2)
  table(datacomplete$activiy)
  
# CREATE POINT 5
  library(dplyr)
  ## select data set with mean and std
  data_final<-datacomplete[c(2,3, grep("mean", names(datacomplete), ignore.case = TRUE),grep("std", names(datacomplete), ignore.case = TRUE))]
  names(data_final)
  group<-group_by(data_final,activiy,subject)
  suma<-summarise_each(group,funs(mean))
  head(suma)
  write.table(group,file = "dataset5.txt",row.names = FALSE)
  list.files()
