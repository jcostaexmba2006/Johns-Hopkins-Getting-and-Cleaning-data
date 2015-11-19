GETTING AND CLEANING DATA
=========================

Course project
--------------

In this course project, we will see an examplo about one of the most exciting areas in all of data science right now, wearable computing, companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

# The experiment

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

# Raw data 

Regarding to the de raw data we find the following files: 

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

# Processed data

Starting for these raw data we have passed the folloving steps:

1-**Merging training and test sets:** to create one data set, included as Inertial Signals Test so Inertial Signals Train 

- load labels activity labels and features

- create features as a vector column names

- Building train1, binding columns with subject, subject, Y_train and   X_train

- Nesting train_inertial_signals

- Building traincomplete, binding train1 toghether to     train_inertial_signals 

- The same process has been followed with Test raw data, forming finally testcomplete

- Then it has been merged both table to create the total dataset. Variables will be indicates in the code book.

2.- **Extracting Mean and standar desviation variables** for each measurement. 

- Library dplyr, data.table and stringr have been loaded

- Grep function has been used in both cases, for 

- Mean columns have been selected from the global dataset

- Trough colmeans the average of each meassurement have been   calculated

- The matrix with names and mean have been formed

- The same process has been followed for standar desviation 

3.- **Descriptive activity names** have been changed to name the activities in the data set with appropriately labels of the data set.  

- Change t for time

- Change f for freq

- Change Acc for Accelerometer

- Change Gyro for Gyroscope

- Variable activity have been coerced to factor with labels

4- Finally an independent data set have been selected with the average of each variable for each activity and each subject.

- Library dplyr have been loaded

- As first step group by have been made with activity and subject

- All the rest of the de variables have been summarized to mean throug summarise function

The end data frame have been exported to a text file with write.table



----------------------------

Jaime Costa Romano

Spain



