#!/bin/bash

is_leap_year ()  # Define function named is_leap_year
{

declare -i year=$1      # declare integer variable "year" and set it to function parm 1

echo -n "$year ($2)-> " # print the year passed in, but do not go to the next line

if (( $year % 4 == 0 )) # if year not dividable by 4, then not a leap year, % is the modulus operator
then
        if (( $year % 400 == 0 ))       # if century dividable by 400, is a leap year
        then
                echo "This is a leap year"
        else
                if (( $year % 100 == 0 )) # if century not divisible by 400, not a leap year
                then
                        echo "This is not a leap year"
                else
                        echo "This is a leap year" # not a century boundary, but dividable by 4, is a leap year
                fi
        fi
else
        echo "This is not a leap year"
fi


}

# test all cases
# call the function is_leap_year several times with two parameters... year and test's expectation for 'is/not leap year.
is_leap_year 1900 not # a leap year
is_leap_year 2000 is  # a leap year
is_leap_year 2001 not # a leap year
is_leap_year 2003 not # a leap year
is_leap_year 2004 is  # a leap year

# Save the above to a file named is_leap_year.sh, then issue the following command to run the 5 tests of the function
# bash is_leap_year.sh
