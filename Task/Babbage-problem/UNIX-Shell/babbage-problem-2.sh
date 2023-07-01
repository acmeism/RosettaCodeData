#!/bin/dash				

#  Babbage problem:
#  	What is the smallest (positive) integer whose square ends in the digits 269,696?
#
#  He found the second to smallest number (99736 instead of 25264) using pencil and paper,
#  and would not have wasted hours of computing time on his (planned) Analytical Engine (AE).
#
#  As most human computers know, a square must end in 0, 1, 4, 5, 6 or 9.
#  because the squares of 0 to 9 end in 0, 1, 4, 9, 6, 5, 6, 9, 4, 1.
#  Thus, the result must have the last digits 14 or 16 in the above case.
#
#  So the algorithm starts with the set {0} and an increment of 1,
#  squaring all numbers of 0+i, and keeping only those that have
#  the correct end digit.
#  Then, the new i is 10*i, and a new set of two digit endings
#  created from the old set of one digit endings, and so on.
#
#  As the AE did not have arrays or the like, the sets must be punched
#  on cards and read in for the next round.
#  The classical (original) Bourne Shell did not have arrays,
#  so you may use this script on very old machines, if 'expr' is used
#  instead of arithmetic expansion.
#  And so his script works with 'dash', the standard command interpreter
#  for non-interactive use.
#
#  To prove the speed, try 1234554321 instead of 269696,
#  the practicall immedidate answer should be 1250061111,
#  while the simple method will take hours.
#
#  Note that this method will stop if there is no solution,
#  while the simple method continues endlessly.

# filename for workfile(s)
wrk=$(basename $0 .sh).data

# set $e to desired ending. Leading zeroes are ignored.
e=${1:-269696}

# set the modulus $m to the power of 10 above $e
m=1
while test $m -le $e
do m=$((m*10))
done

# $a is number to add in each round (power of 10)
a=1

# first workfile contains just the number 0
echo 0 >$wrk	

# test all workfile numbers with another digit in front
while test $a -lt $m		# until the increment excees the modulus
do mm=$((a*10))			# modulus in this round
   ee=$((e % mm))		# ending in this round
   cat $wrk |			# numbers from current workfile
      while read x
      do y=$x			# first number to test is the number read
	 while test $y -le $((x+mm-1))		
	 do z=$(($y * $y))	# calculate the square
	    z=$(($z % $mm))	# ending in this round
	    if test $z -eq $ee	
	    then echo $y	# candidate for next round
	    fi
	    y=$(($y + $a))	# advance leftmost digit
	 done
      done  >$wrk.new		# create new workfile
   # next round
   a=$((a*10))			# another leftmost digit
   mv $wrk.new $wrk		# cycle workfiles
done

# find each number in the last workfile  if x*x mod m = e
# ending in $e and modulus in $m
cat $wrk |			# numbers from last workfile
   while read x
   do y=$(($x * $x))		# check
      y=$(($y % $m))
      if test $y -eq $e
      then echo $x		# solution found
      fi
   done |
   sort -n |    		# numbers in ascending order
   head -n 1 			# show only smallest
