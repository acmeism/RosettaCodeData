class
	APPLICATION

create
	make

feature

	make
		do
			fizzbuzz
		end

	fizzbuzz
	        --Numbers up to 100, prints "Fizz" instead of multiples of 3, and "Buzz" for multiples of 5.
	        --For multiples of both 3 and 5 prints "FizzBuzz".
		do
			across
				1 |..| 100 as c
			loop
				if c.item \\ 15 = 0 then
					io.put_string ("FIZZBUZZ%N")
				elseif c.item \\ 3 = 0 then
					io.put_string ("FIZZ%N")
				elseif c.item \\ 5 = 0 then
					io.put_string ("BUZZ%N")
				else
					io.put_string (c.item.out + "%N")
				end
			end
		end

end
