#!/bin/sh
clear
WIDTH=`tput cols`
HEIGHT=`tput lines`
NUMBARS=8
BARWIDTH=`expr $WIDTH / $NUMBARS`

l="1"    # Set the line counter to 1
while [ "$l" -lt $HEIGHT ]; do
  b="0"    # Bar counter
  while [ "$b" -lt $NUMBARS ]; do
    tput setab $b
    s="0"
    while [ "$s" -lt $BARWIDTH ]; do
      echo -n " "
      s=`expr $s + 1`
    done
    b=`expr $b + 1`
  done
  echo    # newline
  l=`expr $l + 1`
done

tput sgr0    # reset
