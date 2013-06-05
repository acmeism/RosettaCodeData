function cowsbulls()
	print("Welcome to Cows & Bulls! I've picked a number with unique digits between 1 and 9, go ahead and type your guess.\n
		You get one bull for every right number in the right position.\n
		You get one cow for every right number, but in the wrong position.\n
		Enter 'n' to pick a new number and 'q' to quit.\n>")
	function new_number()
		s = [1:9]
		n = ""
		for i = 9:-1:6
			n *= string(delete!(s,rand(1:i)))
		end
		return n
	end
	answer = new_number()
	while true
		input = chomp(readline(STDIN))
		input == "q" && break
		if input == "n"
			answer = new_number()
			print("\nI've picked a new number, go ahead and guess\n>")
			continue
		end
		!ismatch(r"^[1-9]{4}$",input) && (print("Invalid guess: Please enter a 4-digit number\n>"); continue)
		if input == answer
			print("\nYou're right! Good guessing!\nEnter 'n' for a new number or 'q' to quit\n>")
		else
			bulls = sum(answer.data .== input.data)
			cows = sum([answer[x] != input[x] && contains(input.data,answer[x]) for x = 1:4])
			print("\nNot quite! Your guess is worth:\n$bulls Bulls\n$cows Cows\nPlease guess again\n\n>")
		end
	end
end
