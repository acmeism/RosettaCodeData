library(stringi)

testdate <- as.Date("2020-02-02")
count <- 0
while (count < 15) {
  testdate <- testdate + 1
  date_fmt <- format(testdate, "%Y%m%d")
  if (date_fmt == stri_reverse(date_fmt)) {
    cat(as.character(testdate), "\n")
    count <- count + 1
  }
}
