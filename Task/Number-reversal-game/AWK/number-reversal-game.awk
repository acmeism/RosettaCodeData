BEGIN {
	print "\nWelcome to the number reversal game!\n"

	print "You must put the numbers in order from 1 to 9."
	print "Your only moves are to reverse groups of numbers"
	print "on the left side of the list."

	newgame()
	prompt()
}

# start a new game
function newgame(  i, j, t) {
	# score = number of moves
	score = 0

	# list = list of numbers
	split("123456789", list, "")
	do {
		# Knuth shuffle
		for (i = 9; i > 1; i--) {
			j = int(i * rand()) + 1
			t = list[i]
			list[i] = list[j]
			list[j] = t
		}
	} while (win())
}

# numbers in order?
function win(  i) {
	# check if list[1] == 1, list[2] == 2, ...
	for (i = 1; i <= 9; i++) if (list[i] != i) return 0
	return 1
}

# user prompt
function prompt(  i) {
	printf "\nYour list: "
	for (i = 1; i < 9; i++) printf "%d, ", list[i]
	printf "%d\n", list[9]

	if (win()) {
		print "YOU WIN!"
		printf "Your score is %d moves.\n", score
		printf "Would you like to play again (y/n)? "
		again = 1
	} else {
		printf "How many numbers to reverse? "
	}
}

# user input in $1
{
	if (again) {
		again = 0
		if (tolower(substr($1, 1, 1)) == "y")
			newgame()
		else
			exit
	} else {
		score += 1
		reverse($1)
	}
	prompt()
}

function reverse(right,  left, t) {
	left = 1
	while (right > left) {
		t = list[left]
		list[left] = list[right]
		list[right] = t
		left++
		right--
	}
}

END { print "\n\nBye!" }
