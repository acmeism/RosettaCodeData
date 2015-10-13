class
	APPLICATION

create
	make

feature

	make
			-- Test output of the feature hofstadter_q_sequence.
		local
			count, i: INTEGER
			test: ARRAY [INTEGER]
		do
			io.put_string ("%NFirst ten numbers: %N")
			test := hofstadter_q_sequence (10)
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
			test := hofstadter_q_sequence (100000)
			io.put_string ("1000th:%N")
			io.put_integer (test [1000])
			io.put_string ("%NNumber of Flips:%N")
			from
				i := 2
			until
				i > 100000
			loop
				if test [i] < test [i - 1] then
					count := count + 1
				end
				i := i + 1
			end
			io.put_integer (count)
		end

	hofstadter_q_sequence (lim: INTEGER): ARRAY [INTEGER]
			-- Hofstadter Q Sequence up to 'lim'.
		require
			lim_positive: lim > 0
		local
			q: ARRAY [INTEGER]
			i: INTEGER
		do
			create Result.make_filled (1, 1, lim)
			Result [1] := 1
			Result [2] := 1
			from
				i := 3
			until
				i > lim
			loop
				Result [i] := Result [i - Result [i - 1]] + Result [i - Result [i - 2]]
				i := i + 1
			end
		end

end
