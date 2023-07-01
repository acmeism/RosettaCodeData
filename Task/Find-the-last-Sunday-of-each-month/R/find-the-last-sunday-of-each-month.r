last_sundays <- function(year) {
	for (month in 1:12) {
		if (month == 12) {
			date <- as.Date(paste0(year,"-",12,"-",31))
		} else {
			date <- as.Date(paste0(year,"-",month+1,"-",1))-1
		}
		while (weekdays(date) != "Sunday") {
			date <- date - 1
		}
		print(date)
	}
}
last_sundays(2004)
