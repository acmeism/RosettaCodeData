#!/bin/ksh

# Determine the character displayed on the screen at column 3, row 6 and
# store that character in a variable.
#
# Use a group of functions "shellcurses"

#	# Variables:
#
FPATH="/usr/local/functions/shellcurses/"

rst="�[0m"
red="�[31m"
whi="�[37m"

integer row=${1:-6} col=${2:-3}		# Allow command line row col input

#	# 10x10 grid of random digits
#
typeset -A grid
for ((i=0; i<10; i++)); do
	for ((j=0; j<10; j++)); do
		(( grid[${i}][${j}] = (RANDOM % 9) + 1 ))
	done
done

#	# Functions:
#


 ######
# main #
 ######
#	# Initialize the curses screen
#
initscr ; export MAX_LINES MAX_COLS

#	# Display the random number grid with target in red
#
clear
for ((i=1; i<=10; i++)); do
	for ((j=1; j<=10; j++)); do
		colr=${whi}
		(( i == row )) && (( j == col )) && colr=${red}
		mvaddstr ${i} ${j} "${colr}${grid[$((i-1))][$((j-1))]}${rst}"
	done
done

str=$(rtnch ${row} ${col})	# return char at (row, col) location

mvaddstr 12 1 "Digit at (${row},${col}) = ${str}"	# Display result
move 14 1
refresh
endwin
