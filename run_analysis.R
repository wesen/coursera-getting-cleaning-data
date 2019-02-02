library(tidyverse)


# Take a look at the training data
readLines("data/UCI HAR Dataset/train/X_train.txt", n=3)
readLines("data/UCI HAR Dataset/train/Y_train.txt", n=3)

# Load the features names
feature_names <- read_delim(
  "data/UCI HAR Dataset/features.txt",
  delim = " ",
  col_types = cols(col_integer(), col_character()),
  col_names = c("id", "name")
)

# Load the activity labels
activity_labels <- read_delim(
  "data/UCI HAR Dataset/activity_labels.txt",
  delim = " ",
  col_names = c("id", "name"),
  col_types = cols(col_integer(), col_character())
)

# Function to load the dataset of a specific type (either "test" or "train").
# This assumes the UCI HAR Dataset has been unpacked into the data/ directory.
load_uci_data <- function(name, n_max=Inf) {
  dir <- paste0("data/UCI HAR Dataset/", name, "/")

  # load the actual measurements
  data <- read_delim(
    paste0(dir, "X_", name, ".txt"),
    col_names = feature_names$name,
    delim = " ",
    trim_ws = TRUE,
    n_max = n_max
  ) %>%
    select(contains("mean()"), contains("std()"))

  # load the subjects table
  subjects <- read_csv(
    paste0(dir, "subject_", name, ".txt"),
    col_names = c("subject"),
    col_types = cols(col_integer()),
    n_max = n_max
  )

  # load the activity labels
  labels <- read_csv(
    paste0(dir, "y_", name, ".txt"),
    col_names = c("label"),
    col_types = cols(col_integer()),
    n_max = n_max
  )

  # assign the subjects, and convert the labels into a factor variable
  data$subject <- subjects$subject
  data$label <- factor(labels$label, levels=activity_labels$id, labels=activity_labels$name)

  data %>%
    select(subject, label, everything())
}

# load the train data
train_data <- load_uci_data("train", n_max=Inf)
test_data <- load_uci_data("test", n_max=Inf)

# combine train and test data
data <- bind_rows(train_data, test_data)

# create a tidy dataset
tidy_data <- data %>%
  gather(name, value, -subject, -label) %>%
  group_by(subject, label, name) %>%
  summarize(average=mean(value))

write.table(tidy_data, "data/tidy_data.txt")
