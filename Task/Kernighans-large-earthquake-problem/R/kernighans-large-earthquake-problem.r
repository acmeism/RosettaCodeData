earthquakes <- read.table("data.txt", col.names=c("date", "name", "magnitude"))
subset(earthquakes, magnitude>6)
