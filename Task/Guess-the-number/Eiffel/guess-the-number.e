class
	APPLICATION

create
	make

feature {NONE}

	make
		local
			number, seed: INTEGER_32
			random: RANDOM
		do
			from
			until
				seed > 0
			loop
				io.put_string ("Enter a positive integer.%NYour play will be generated from it.%N")
				io.read_integer
				seed := io.last_integer
			end
			create random.set_seed (seed)
			number := (random.double_i_th (seed) * 10.0).truncated_to_integer + 1
			io.put_string ("Please guess the number!%N")
			from
				io.read_integer
			until
				io.last_integer = number
			loop
				io.put_string ("Please guess again!%N")
				io.read_integer
			end
			io.put_string ("Well guessed!%N")
		end

end
