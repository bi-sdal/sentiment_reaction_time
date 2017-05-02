library(readr)
library(magrittr)

rm(list = ls())

LARGEST_ID <- 10

ids <- read_delim(file = 'data/allAnonymizedSubjectStats.txt', delim = '\t', skip = 1,
                  col_names = c('uuid', 'var1', 'sub_num', 'var2', 'var3'))

df <- read_delim(file = 'data/allSubjectActionsOutput.txt', delim = '\t',)

ids$id <- as.numeric(ids$sub_num)
ids <- ids[ids$id < LARGEST_ID, ]
ids <- ids[complete.cases(ids), ]

data <- merge(x = df, y = ids, by.x = 'subjuuid', by.y = 'uuid')

good_uuid <- ids$uuid

data <- data %>%
  filter(subjuuid %in% good_uuid)

save(data, file = 'output/data.RData')
