class
	SELF_REFERENTIAL_SEQUENCE

create
	make

feature

	make
		local
			i: INTEGER
			length, max: INTEGER_64
		do
			create seed_value.make
			create sequence.make (25)
			create permuted_values.make
			from
				i := 1
			until
				i > 1000000
			loop
				length := check_length (i.out)
				if length > max then
					max := length
					seed_value.wipe_out
					seed_value.extend (i)
				elseif length = max then
					seed_value.extend (i)
				end
				sequence.wipe_out
				i := next_ascending (i).to_integer
			end
			io.put_string ("Maximal length: " + max.out)
			io.put_string ("%NSeed Value: %N")
			across
				seed_value as s
			loop
				permute (s.item.out, 1)
			end
			across
				permuted_values as p
			loop
				io.put_string (p.item + "%N")
			end
			io.put_string ("Sequence:%N")
			max := check_length (seed_value [1].out)
			across
				sequence as s
			loop
				io.put_string (s.item)
				io.new_line
			end
		end

	next_ascending (n: INTEGER_64): STRING
			-- Next number with ascending digits after 'n'.
			-- Numbers with trailing zeros are treated as ascending numbers.
		local
			st: STRING
			first, should_be, zero: STRING
			i: INTEGER
		do
			create Result.make_empty
			create zero.make_empty
			st := (n + 1).out
			from
			until
				st.count < 2
			loop
				first := st.at (1).out
				if st [2] ~ '0' then
					from
						i := 3
					until
						i > st.count
					loop
						zero.append ("0")
						i := i + 1
					end
					Result.append (first + first + zero)
					st := ""
				else
					should_be := st.at (2).out
					if first > should_be then
						should_be := first
					end
					st.remove_head (2)
					st.prepend (should_be)
					Result.append (first)
				end
			end
			if st.count > 0 then
				Result.append (st [st.count].out)
			end
		end

feature {NONE}

	seed_value: SORTED_TWO_WAY_LIST [INTEGER]

	permuted_values: SORTED_TWO_WAY_LIST [STRING]

	sequence: ARRAYED_LIST [STRING]

	permute (a: STRING; k: INTEGER)
			-- All permutations of 'a'.
		require
			count_positive: a.count > 0
			k_valid_index: k > 0
		local
			t: CHARACTER
			b: STRING
			found: BOOLEAN
		do
			across
				permuted_values as p
			loop
				if p.item ~ a then
					found := True
				end
			end
			if k = a.count and a [1] /= '0' and not found then
				create b.make_empty
				b.deep_copy (a)
				permuted_values.extend (b)
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

	check_length (i: STRING): INTEGER_64
			-- Length of the self referential sequence starting with 'i'.
		local
			found: BOOLEAN
			j: INTEGER
			s: STRING
		do
			create s.make_from_string (i)
			from
			until
				found
			loop
				sequence.extend (s)
				s := next (s)
				from
					j := sequence.count - 1
				until
					j < 1
				loop
					if sequence [j] ~ s then
						found := True
					end
					j := j - 1
				end
			end
			Result := sequence.count
		end

	next (n: STRING): STRING
			-- Next item after 'n' in a self referential sequence.
		local
			i, count: INTEGER
			counter: ARRAY [INTEGER]
		do
			create counter.make_filled (0, 0, 9)
			create Result.make_empty
			from
				i := 1
			until
				i > n.count
			loop
				count := n [i].out.to_integer
				counter [count] := counter [count] + 1
				i := i + 1
			end
			from
				i := 9
			until
				i < 0
			loop
				if counter [i] > 0 then
					Result.append (counter [i].out + i.out)
				end
				i := i - 1
			end
		end

end
