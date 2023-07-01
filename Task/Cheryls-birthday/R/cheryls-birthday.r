options <- dplyr::tibble(mon = rep(c("May", "June", "July", "August"),times = c(3,2,2,3)),
                         day = c(15, 16, 19, 17, 18, 14, 16, 14, 15, 17))

okMonths <- c()
#  Albert's first clue - it is a month with no unique day
for (i in unique(options$mon)){
  if(all(options$day[options$mon == i] %in% options$day[options$mon != i])) {okMonths <- c(okMonths, i)}
}

okDays <- c()
#  Bernard's clue - it is a day that only occurs once in the remaining dates
for (i in unique(options$day)){
  if(!all(options$mon[options$day == i] %in% options$mon[(options$mon %in% okMonths)])) {okDays <- c(okDays, i)}
}

remaining <- options[(options$mon %in% okMonths) & (options$day %in% okDays), ]
# Albert's second clue - must be a month with only one un-eliminated date
for(i in unique(remaining$mon)){
  if(sum(remaining$mon == i) == 1) {print(remaining[remaining$mon == i,])}
}
