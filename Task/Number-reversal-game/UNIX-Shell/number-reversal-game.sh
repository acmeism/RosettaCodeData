print "\nWelcome to the number reversal game!\n"

print "You must put the numbers in order from 1 to 9."
print "Your only moves are to reverse groups of numbers"
print "on the left side of the list."

integer list score

# start a new game
function newgame {
	integer i j t

	# score = number of moves
	((score = 0))

	# list = array of numbers
	set -A list 1 2 3 4 5 6 7 8 9
	while true; do
		# Knuth shuffle
		((i = 9))
		while ((i > 1)); do
			# get random j from 0 to i - 1
			((j = RANDOM))
			((j < 32768 % i)) && continue
			((j %= i))

			# decrement i, swap list[i] with list[j]
			((i -= 1))
			((t = list[i]))
			((list[i] = list[j]))
			((list[j] = t))
		done
		win || break
	done
}

# numbers in order?
function win {
	integer i

	# check if list[0] == 1, list[1] == 2, ...
	((i = 0))
	while ((i < 9)); do
		((list[i] != i + 1)) && return 1
		((i += 1))
	done
	return 0
}

# reverse first $1 elements of list
function reverse {
	integer left right t

	((left = 0))
	((right = $1 - 1))
	while ((right > left)); do
		((t = list[left]))
		((list[left] = list[right]))
		((list[right] = t))
		((left += 1))
		((right -= 1))
	done
}


integer i

newgame
while true; do
	print -n "\nYour list: "
	((i = 0))
	while ((i < 8)); do
		printf "%d, " ${list[i]}
		((i += 1))
	done
	printf "%d\n" ${list[8]}

	if win; then
		print "YOU WIN!"
		printf "Your score is %d moves.\n" $score
		print -n "Would you like to play again (y/n)? "

		if read again && [[ $again = @(y|Y)* ]]; then
			newgame
		else
			print "\n\nBye!"
			exit
		fi
	else
		print -n "How many numbers to reverse? "

		if read i; then
			((score += 1))
			reverse $i
		else
			print "\n\nBye!"
			exit
		fi
	fi
done
