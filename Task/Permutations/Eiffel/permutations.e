class
	APPLICATION

create
	make

feature {NONE}

	make
		do
			test := <<2, 5, 1>>
			permute (test, 1)
		end

	test: ARRAY [INTEGER]

	permute (a: ARRAY [INTEGER]; k: INTEGER)
			-- All permutations of 'a'.
		require
			count_positive: a.count > 0
			k_valid_index: k > 0
		local
			t: INTEGER
		do
			if k = a.count then
				across
					a as ar
				loop
					io.put_integer (ar.item)
				end
				io.new_line
			else
				across
					k |..| a.count as c
				loop
					t := a [k]
					a [k] := a [c.item]
					a [c.item] := t
					permute (a, k + 1)
					t := a [k]
					a [k] := a [c.item]
					a [c.item] := t
				end
			end
		end

end
