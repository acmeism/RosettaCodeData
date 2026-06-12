days2ord <- function(days, offset){
  raw_date <- as.Date(days, origin=paste0(offset, "-01-01", collapse=""))
  format(raw_date, "%d/%m/%Y")
}

daycounts <- c(0, 109573, 146096)
offsets <- 400*(0:5)
dates <- outer(daycounts, offsets, Vectorize(days2ord))
dates_full <- cbind(paste("Day count:", daycounts), dates, rep("", 3))
writeLines(t(dates_full))
