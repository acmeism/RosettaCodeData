#!/usr/bin/env bash

day-of-the-week()
  if [[ "$1" =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]
  then
    local -ra names=({Sun,Mon,Tues,Wednes,Thurs,Fri,Satur}day) doomsday=({37,41}7426415375)
    local -i i c s t a b
    local -i {year,month,day}=${BASH_REMATCH[++i]}
    echo ${names[
      c=year/100,
      s=(year%100)/12,
      t=(year % 100) % 12,
      a=(5*(c%4)+2) % 7,
      b=(s + t + (t / 4) + a ) % 7,
      (b + day - ${doomsday[(year%4 == 0) && ((year%100) || (year%400 == 0))]:month-1:1} + 7) % 7
    ]}
  else return 1
  fi

for date in 1800-01-06 1875-03-29 1915-12-07 1970-12-23 2043-05-14 2077-02-12 2101-04-02
do day-of-the-week "$date"
done
