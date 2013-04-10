years <- 2008:2121
xmas <- as.POSIXlt(paste(years, '/12/25', sep=""))
years[xmas$wday==0]
