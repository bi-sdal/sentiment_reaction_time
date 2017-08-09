library(readr)
library(magrittr)

rm(list = ls())

LARGEST_ID <- 50

sub_stats <- list.files(path = 'data', pattern = '*allAnonymizedSubjectStats*', full.names = TRUE)
sub_actions <- list.files(path = 'data', pattern = '*allSubjectActionsOutput*', full.names = TRUE)

id_data_l <- lapply(X = sub_stats, FUN = read_delim, delim = '\t', skip = 1,
                  col_names = c('uuid', 'var1', 'sub_num', 'var2', 'var3'))

action_data_l <- lapply(X = sub_actions, FUN = read_delim, delim = '\t')

ids <- do.call(what = rbind, args = id_data_l)
df <- do.call(rbind, action_data_l)

ids$id <- as.numeric(ids$sub_num)
ids <- ids[ids$id < LARGEST_ID, ]

missing_cols <- sapply(ids, function(x) all(is.na(x)))
ids <- ids[, !missing_cols]
ids <- ids[complete.cases(ids), ]

data <- merge(x = df, y = ids, by.x = 'subjuuid', by.y = 'uuid')

good_uuid <- ids$uuid

data <- data %>%
  filter(subjuuid %in% good_uuid)

save(data, file = 'output/data.RData')
