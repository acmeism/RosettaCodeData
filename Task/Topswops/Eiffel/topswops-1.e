class
	TOPSWOPS

create
	make

feature

	make (n: INTEGER)
			-- Topswop game.
		local
			perm, ar: ARRAY [INTEGER]
			tcount, count: INTEGER
		do
			create perm_sol.make_empty
			create solution.make_empty
			across
				1 |..| n as c
			loop
				create ar.make_filled (0, 1, c.item)
				across
					1 |..| c.item as d
				loop
					ar [d.item] := d.item
				end
				permute (ar, 1)
				across
					1 |..| perm_sol.count as e
				loop
					tcount := 0
					from
					until
						perm_sol.at (e.item).at (1) = 1
					loop
						perm_sol.at (e.item) := reverse_array (perm_sol.at (e.item))
						tcount := tcount + 1
					end
					if tcount > count then
						count := tcount
					end
				end
				solution.force (count, c.item)
			end
		end

	solution: ARRAY [INTEGER]

feature {NONE}

	perm_sol: ARRAY [ARRAY [INTEGER]]

	reverse_array (ar: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Array with 'ar[1]' elements reversed.
		require
			ar_not_void: ar /= Void
		local
			i, j: INTEGER
		do
			create Result.make_empty
			Result.deep_copy (ar)
			from
				i := 1
				j := ar [1]
			until
				i > j
			loop
				Result [i] := ar [j]
				Result [j] := ar [i]
				i := i + 1
				j := j - 1
			end
		ensure
			same_elements: across ar as a all Result.has (a.item) end
		end

	permute (a: ARRAY [INTEGER]; k: INTEGER)
			-- All permutations of array 'a' stored in perm_sol.
		require
			ar_not_void: a.count >= 1
			k_valid_index: k > 0
		local
			i, t: INTEGER
			temp: ARRAY [INTEGER]
		do
			create temp.make_empty
			if k = a.count then
				across
					a as ar
				loop
					temp.force (ar.item, temp.count + 1)
				end
				perm_sol.force (temp, perm_sol.count + 1)
			else
				from
					i := k
				until
					i > a.count
				loop
					t := a [k]
					a [k] := a [i]
					a [i] := t
					permute (a, k + 1)
					t := a [k]
					a [k] := a [i]
					a [i] := t
					i := i + 1
				end
			end
		end

end
