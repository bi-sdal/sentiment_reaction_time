library(readr)
library(testthat)

rm(list = ls())

# This number is used to distinguish between test IDs and actual IDs
# IDs larger than this number will be dropped
LARGEST_ID <- 50

# Load data and test column names ####

df <- read_delim("data/merged-allSubjectActionsOutput.txt",
                                 "\t", escape_double = FALSE, trim_ws = TRUE)

ids <- read_delim("data/merged-allAnonymizedSubjectStats.txt",
                            "\t", escape_double = FALSE, trim_ws = TRUE)

expect_equal(names(df),
             c("subjuuid", "word", "category", "choice", "rt", "order"),
             label = 'Column names in the subject action df')

expect_equal(names(ids),
             c("UUID", "dateStarted", "username", "Real"),
             label = 'Column names in the subject stats df')


# Clean columns for export ####

# Assumes that the username is a numeric
# some of them contain letters, which were mainly used for testing
ids$username <- as.numeric(ids$username)
ids <- ids[ids$username <= LARGEST_ID, ]

# there should be no missing data in this dataset
ids <- ids[complete.cases(ids), ]

data <- merge(x = df, y = ids, by.x = 'subjuuid', by.y = 'UUID')

save(data, file = 'output/data.RData')
