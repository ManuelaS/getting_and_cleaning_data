# Code book
## Coursera Getting and Cleaning Data
### Course Project

#### Description
This code book describes the source dataset and the data analysis pipeline leading to the generation of the txt file 'tidy_dataset.txt'.

#### Setup
    1. Set working directory
    2. Load (or install if necessary) the following packages:
        * 'data.table';
        * 'plyr';
        * 'dplyr';
    3. Source the script 'run_analysis.R'

#### Source dataset
 The dataset is available for download [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). For a detailed description of the experimental design and motivation along with data collection, please refer to ['Human Activity Recognition Using Smartphones Data Set'](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#### Data processing

##### Downloading and loading data
Code to download the and extract data is included in run_analysis. The resulting folder 'UCI HAD Dataset' will include:
    * 'README.txt';
    * 'features_info.txt';
    * 'features.txt':
    * 'activity_labels.txt';
    * 'train folder':
        * 'Inertial Signals' folder: ignored for the purpose of this assignment;
        * 'subject_train.txt';
        * 'X_train.txt';
        * 'y_train.txt';
    * test folder:
        * 'Inertial Signals' folder: ignored for the purpose of this assignment;
        * 'subject_test.txt';
        * 'X_test.txt';
        * 'y_test.txt';

##### Data processing
    1. Merge train (7352 observation of 561 variables) and test(2947 observation of 561 variables) dataset, resulting in 10299x561 data frame. Columns are of format numeric (range -1 to +1) containing measurements;

    2. Load features.txt into a dataframe (561 observation mapping a numeric feature_id to a descriptive feature id) and retain only features which include either 'mean' or 'std' in their label;

    3. Loads activity_labels.txt and join these descriptive names by the labels numeric id with the dataset described above:
        * there are 6 legal levels:
            * laying, sitting, standing, walking, walkingdownstairs, walkingupstairs; 

    4. Rename activity headers with more descriptive names to clarify their content:
        * remove '()';
        * replace '-mean' and '-std' with 'Mean and Std', respectively;
        * replace 't' and 'f' at the beginning of the headers with 'Time' and 'Frequency', respectively;
        * replaced some key tokens with the full-on spell version, for example 'Acc' with 'Acceleration';

   5. Grouped the dataset by activity type and subject, computed the average for each measurement and exported the resulting table to 'tidy_dataset.txt');
