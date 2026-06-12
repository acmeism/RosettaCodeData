# return true if year is leap in Gregorian calendar
leap() {
  local -i year
  year=$1
  if (( year % 4 )); then return 1; fi
  if (( year % 100 )); then return 0; fi
  ! (( year % 400 ))
}

# convert date to Gregorian day count (Rata Die), where RD 1 = January 1, 1 CE
rd() {
   local year month day
   IFS=- read year month day <<<"$1"
   local -i elapsed_years=year-1
   (( day += elapsed_years * 365 ))
   (( day += elapsed_years/4 ))
   (( day -= elapsed_years/100 ))
   (( day += elapsed_years/400 ))
   local month_lengths=(31 28 31 30 31 30 31 31 30 31 30 31)
   if leap "$year"; then let month_lengths[1]+=1; fi
   local m
   for (( m=0; m<month-1; ++m)); do
     (( day += month_lengths[m] ))
   done
   printf '%d\n' "$day"
}

days_between() {
  local -i date1 date2
  date1=$(rd "$1")
  date2=$(rd "$2")
  printf '%d\n' $(( date2 - date1 ))
}

days_between 1970-01-01 2019-12-04
