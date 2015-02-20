class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
		    number : INTEGER_32 -- Number to guess
		    random : RANDOM
		do
		    create random.make
                    number := (random.double_item*10.0).truncated_to_integer + 1
                    print ("I'm thinking of a number between 1 and 10.%N")
		    print ("Please guess the number!%N")

		    from io.read_integer
		    until io.last_integer = number
		    loop
			    print ("Sorry. Please guess again!%N")
			    io.read_integer
		    end
			
                    print ("Correct!%N")
		end

end
