class
	APPLICATION

create
	make

feature

	make
		do
			twelve_days_of_christmas
		end

feature {NONE}

	twelve_days_of_christmas
			-- Christmas carol: Twelve days of christmas.
		local
			i, j: INTEGER
		do
			create gifts.make_empty
			create days.make_empty
			gifts := <<"A partridge in a pear tree.", "Two turtle doves and", "Three french hens", "Four calling birds", "Five golden rings", "Six geese a-laying", "Seven swans a-swimming", "Eight maids a-milking", "Nine ladies dancing", "Ten lords a-leaping", "Eleven pipers piping", "Twelve drummers drumming", "And a partridge in a pear tree.", "Two turtle doves">>
			days := <<"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "Twelfth">>
			from
				i := 1
			until
				i > days.count
			loop
				io.put_string ("On the " + days [i] + " day of Christmas.%N")
				io.put_string ("My true love gave to me:%N")
				from
					j := i
				until
					j <= 0
				loop
					if i = 12 and j = 2 then
						io.put_string (gifts [14] + "%N")
						io.put_string (gifts [13] + "%N")
						j := j - 1
					else
						io.put_string (gifts [j] + "%N")
					end
					j := j - 1
				end
				io.new_line
				i := i + 1
			end
		end

	gifts: ARRAY [STRING]

	days: ARRAY [STRING]

end
