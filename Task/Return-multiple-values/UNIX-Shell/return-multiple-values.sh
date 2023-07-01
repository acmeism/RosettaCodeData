#!/bin/sh
funct1() {
  a=$1
  b=`expr $a + 1`
  echo $a $b
}

values=`funct1 5`

set $values
x=$1
y=$2
echo "x=$x"
echo "y=$y"
