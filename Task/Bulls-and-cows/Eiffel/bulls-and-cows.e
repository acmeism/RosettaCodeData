class
	BULLS_AND_COWS

create
	execute

feature

	execute
			-- Initiate game.
		do
			io.put_string ("Let's play bulls and cows.%N")
			create answer.make_empty
			play
		end

feature {NONE}

	play
			-- Plays bulls ans cows.
		local
			count, seed: INTEGER
			guess: STRING
		do
			from
			until
				seed > 0
			loop
				io.put_string ("Enter a positive integer.%NYour play will be generated from it.%N")
				io.read_integer
				seed := io.last_integer
			end
			generate_answer (seed)
			io.put_string ("Your game has been created.%N Try to guess the four digit number.%N")
			create guess.make_empty
			from
			until
				guess ~ answer
			loop
				io.put_string ("Guess: ")
				io.read_line
				guess := io.last_string
				if guess.count = 4 and guess.is_natural and not guess.has ('0') then
					io.put_string (score (guess) + "%N")
					count := count + 1
				else
					io.put_string ("Your input does not have the correct format.")
				end
			end
			io.put_string ("Congratulations! You won with " + count.out + " guesses.")
		end

	answer: STRING

	generate_answer (s: INTEGER)
			-- Answer with 4-digits between 1 and 9 stored in 'answer'.
		require
			positive_seed: s > 0
		local
			random: RANDOM
			ran: INTEGER
		do
			create random.set_seed (s)
			from
			until
				answer.count = 4
			loop
				ran := (random.double_item * 10).floor
				if ran > 0 and not answer.has_substring (ran.out) then
					answer.append (ran.out)
				end
				random.forth
			end
		ensure
			answer_not_void: answer /= Void
			correct_length: answer.count = 4
		end

	score (g: STRING): STRING
			-- Score for the guess 'g' depending on 'answer'.
		require
			same_length: answer.count = g.count
		local
			k: INTEGER
			a, ge: STRING
		do
			Result := ""
			a := answer.twin
			ge := g.twin
			across
				1 |..| a.count as c
			loop
				if a [c.item] ~ ge [c.item] then
					Result := Result + "BULL "
					a [c.item] := ' '
					ge [c.item] := ' '
				end
			end
			across
				1 |..| a.count as c
			loop
				if a [c.item] /= ' ' then
					k := ge.index_of (a [c.item], 1)
					if k > 0 then
						Result := Result + "COW "
						ge [k] := ' '
					end
				end
			end
		end

end
