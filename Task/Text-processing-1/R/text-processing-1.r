#Read in data from file
dfr <- read.delim("readings.txt")
#Calculate daily means
flags <- as.matrix(dfr[,seq(3,49,2)])>0
vals <- as.matrix(dfr[,seq(2,49,2)])
daily.means <- rowSums(ifelse(flags, vals, 0))/rowSums(flags)
#Calculate time between good measurements
times <- strptime(dfr[1,1], "%Y-%m-%d", tz="GMT") + 3600*seq(1,24*nrow(dfr),1)
hours.between.good.measurements <- diff(times[t(flags)])/3600
