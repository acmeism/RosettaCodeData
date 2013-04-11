# Read in data from file
dfr <- read.delim("d:/readings.txt", colClasses=c("character", rep(c("numeric", "integer"), 24)))
dates <- strptime(dfr[,1], "%Y-%m-%d")

# Any bad values?
dfr[which(is.na(dfr))]

# Any duplicated dates
dates[duplicated(dates)]

# Number of rows with no bad values
flags <- as.matrix(dfr[,seq(3,49,2)])>0
sum(apply(flags, 1, all))
