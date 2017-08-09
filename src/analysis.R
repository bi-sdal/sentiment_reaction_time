library(dplyr)
library(ggplot2)

ids <- read.table(file = 'data/merged-allAnonymizedSubjectStats.txt',
                  header = FALSE, sep = '\t', stringsAsFactor = FALSE, skip = 1)

df <- read.table(file = 'data/merged-allSubjectActionsOutput.txt',
                 header = TRUE, sep = '\t', stringsAsFactor = FALSE)

ids$id <- as.numeric(as.character(ids$V3))
ids <- ids[ids$id < 10, ]

good_ids <- as.character(ids$V1)
good_ids <- good_ids[!is.na(good_ids)]

df <- merge(x = df, y = ids, by.x = 'subjuuid', by.y = 'V1')

stats_f <- df %>%
    filter(subjuuid %in% good_ids)

stats <- stats_f%>%
    group_by(category) %>%
    summarize(avg_rt = mean(rt),
              sd_rt = sd(rt),
              q1 = quantile(rt, 0.25),
              q3 = quantile(rt, 0.75))

print(stats)


## Word analysis
## get 'fast' and 'slow' reaction time words
## uses the q1 and q3 quantile as cutoffs per category

fbt <- as.numeric(stats[stats$category == 'realbad', 'q1'])
fgt <- as.numeric(stats[stats$category == 'realgood', 'q1'])

fast_bad_words <- stats_f[stats_f$rt <=  fbt & stats_f$category == 'realbad', 'word']
fast_good_words <- stats_f[stats_f$rt <= fgt & stats_f$category == 'realgood', 'word']

sbt <- as.numeric(stats[stats$category == 'realbad', 'q3'])
sgt <- as.numeric(stats[stats$category == 'realgood', 'q1'])

slow_bad_words <- stats_f[stats_f$rt >= sbt & stats_f$category == 'realbad', 'word']
slow_good_words <- stats_f[stats_f$rt >= sgt & stats_f$category == 'realgood', 'word']

## show word results

fast_bad_words
fast_good_words
slow_bad_words
slow_good_words

## Descriptive plots

df <- df[df$subjuuid %in% good_ids, ]

g <- ggplot(data = df, aes(x = rt)) +
    facet_grid(category~id) +
    theme_minimal()

## histogram ploy by category and ID
g + geom_histogram()

## density plot by category and ID
g + geom_density()

## density plot by category only
ggplot(data = df, aes(x = rt, color = category)) +
    geom_density() +
    theme_minimal()

print(stats)
