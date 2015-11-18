class
	APPLICATION

create
	make

feature

	make
		local
			k, count: INTEGER
		do
			create ludic.make (22000)
			io.put_string ("%NLudic numbers up to 25. %N")
			across
				ludic.ludic_numbers.subarray (1, 25) as ld
			loop
				io.put_string (ld.item.out + "%N")
			end
			io.put_string ("%NLudic numbers from 2000 ... 2005. %N")
			across
				ludic.ludic_numbers.subarray (2000, 2005) as ld
			loop
				io.put_string (ld.item.out + "%N")
			end
			io.put_string ("%NNumber of Ludic numbers smaller than 1000. %N")
			from
				k := 1
			until
				ludic.ludic_numbers [k] >= 1000
			loop
				k := k + 1
				count := count + 1
			end
			io.put_integer (count)
		end

	ludic: LUDIC_NUMBERS

end
