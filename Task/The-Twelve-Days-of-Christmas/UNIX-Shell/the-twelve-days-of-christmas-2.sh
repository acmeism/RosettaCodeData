#!/bin/sh
ordinal() {
  n=$1
  set first   second third fourth fifth    sixth \
      seventh eighth ninth tenth  eleventh twelfth
  shift $n
  echo $1
}

gift() {
  n=$1
  set "A partridge in a pear tree." "Two turtle doves and"      \
      "Three French hens,"          "Four calling birds,"       \
      "Five gold rings,"            "Six geese a-laying,"       \
      "Seven swans a-swimming,"     "Eight maids a-milking,"    \
      "Nine ladies dancing,"        "Ten lords a-leaping,"      \
      "Eleven pipers piping,"       "Twelve drummers drumming,"
  shift $n
  echo "$1"
}

echo_gifts() {
  day=$1
  echo "On the `ordinal $day` day of Christmas, my true love sent to me:"
  for i in `seq $day 0`; do
    gift $i
  done
  echo
}

for day in `seq 0 11`; do
  echo_gifts $day
done
