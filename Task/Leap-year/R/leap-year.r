isLeapYear <- function(year) {
    ifelse(year%%100==0, year%%400==0, year%%4==0)
}

for (y in c(1900, 1994, 1996, 1997, 2000)) {
  cat(y, ifelse(isLeapYear(y), "is", "isn't"), "a leap year.\n")
}
