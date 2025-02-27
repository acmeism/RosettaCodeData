#!/usr/bin/env bash

day-of-the-week()
  if [[ "$1" =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]
  then
    local -ra names=({Sun,Mon,Tues,Wednes,Thurs,Fri,Satur}day) doomsday=({37,41}7426415375)
    local -i i c s t a b
    local -i {y,m,d}=${BASH_REMATCH[++i]}
    echo ${names[
      c=y/100,
      s=(y%100)/12,
      t=(y % 100) % 12,
      a=(5*(c%4)+2) % 7,
      b=(s + t + (t / 4) + a ) % 7,
      (b + d - ${doomsday[(y%4 == 0) && ((y%100) || (y%400 == 0))]:m-1:1} + 7) % 7
    ]}
  else return 1
  fi

for date in 1800-01-06 1875-03-29 1915-12-07 1970-12-23 2043-05-14 2077-02-12 2101-04-02
do day-of-the-week "$date"
done
