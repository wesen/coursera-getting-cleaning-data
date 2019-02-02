# coursera-getting-cleaning-data


## Script working

The script first loads the `activity_labels.txt` and `features.txt` files of the dataset,
to get meaningful labels for the activities, and column names for the feature measurements.

We then define a helper function to load the datasets out of either the test or the train directory.
We load the measurements, using the column names from the `features.txt` file. 
We keep only the columns that contain `mean()` or `std()` (the mean and standard deviation of a measurement).

We then load the subjects and activity labels files, 
transform the activity labels into a factor using the labels found in `activity_labels.txt`,
and return a tibble.

The concatenate the test and train datasets into the `data` variable.

Finally, we tidy the dataset: 
we gather all the columns except subject and label, so that we get a single row for each measurement.
We then group by subject, label, name, and summarize the average of each measurement.


## Code book

* `subject` - the subject ID 
* `label` - the activity label, one of:
   * WALKING
   * WALKING_UPSTAIRS
   * WALKING_DOWNSTAIRS
   * SITTING
   * STANDING
   * LAYING
* `name` - the measurement name. Refer to the features_info.txt file of the UCI HAR Dataset for a detailed overview.
* `average` - the average of the measurement for the activity recording for this subject and activity
