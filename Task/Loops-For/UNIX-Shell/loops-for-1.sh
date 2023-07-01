#!/bin/sh
# Using a while control construct to emulate a for loop

l="1"                   # Set the counters to one
while [ "$l" -le 5 ]    # Loop while the counter is less than five
  do
  m="1"
  while [ "$m" -le "$l" ]  # Loop while the counter is less than five
    do
    printf "*"
    m=`expr "$m" + 1`   # Increment the inner counter
  done
  echo
  l=`expr "$l" + 1`   # Increment the outer counter
done
