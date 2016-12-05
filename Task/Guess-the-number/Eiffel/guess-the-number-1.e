class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			number_to_guess: INTEGER
		do
			number_to_guess := (create {RANDOMIZER}).random_integer_in_range (1 |..| 10)
			from
				print ("Please guess the number!%N")
				io.read_integer
			until
				io.last_integer = number_to_guess
			loop
				print ("Please, guess again!%N")
				io.read_integer
			end
			print ("Well guessed!%N")
		end

end
