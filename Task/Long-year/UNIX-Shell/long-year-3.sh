dec31wd() {
  # return weekday (time_t tm_wday, 0=Sunday) of December 31st of the given year
  typeset -i y=$1
  echo $(( (y + y / 4 - y / 100 + y / 400) % 7 ))
}

# the year is long if the year starts or ends on a Thursday (starts on a
# Thursday = the previous year ends on a Wednesday)
long_year() {
   typeset -i y=$1
   (( 4 == $(dec31wd $y) || 3 == $(dec31wd $(( y - 1 ))) ))
}
