class
	KNAPSACKZEROONE

create
	make

feature

	items: ARRAY [ITEM]

	max_weight: INTEGER

feature

	make (a_max_weight: INTEGER)
			-- Make an empty knapsack.
		require
			a_max_weight >= 0
		do
			create items.make_empty
			max_weight := a_max_weight
		end

	add_item (item: ITEM)
			-- Add 'item' to knapsack.
		local
			temp: ITEM
		do
			create temp.make_from_other (item)
			items.force (item, items.count + 1)
		end

	compute_solution
		local
			M: ARRAY [INTEGER]
			n: INTEGER
			i, j: INTEGER
			w_i, v_i: INTEGER
			item_i: ITEM
			final_items: LINKED_LIST [ITEM]
		do
			n := items.count
			create M.make_filled (0, 1, n * max_weight)
			from
				i := 2
			until
				(i > n)
			loop
				from
					j := 1
				until
					j > max_weight
				loop
					item_i := items [i]
					w_i := item_i.weight
					if w_i <= j then
						v_i := item_i.value
						M [(i - 1) * max_weight + j] := max (M [(i - 2) * max_weight + j], M [(i - 2) * max_weight + j - w_i + 1] + v_i)
					else
						M [(i - 1) * max_weight + j] := M [(i - 2) * max_weight + j]
					end
					j := j + 1
				end
				i := i + 1
			end
			io.put_string ("The final value of the knapsack will be: ")
			io.put_integer (M [(n - 1) * max_weight + max_weight]);
			io.new_line
				--compute the items that fit into the knapsack
			create final_items.make
			io.put_string ("We'll take the following items: %N");
			from
				i := n
				j := max_weight
			until
				i <= 1 or j <= 1
			loop
				item_i := items [i]
				w_i := item_i.weight
				if w_i <= j then
					v_i := item_i.value
					if M [(i - 1) * max_weight + j] = M [(i - 2) * max_weight + j] then
					else
						final_items.extend (item_i)
						io.put_string (item_i.name)
						io.new_line
						j := j - w_i
					end
				else
				end
				i := i - 1
			end
		end

feature {NONE}

	max (a, b: INTEGER): INTEGER
			-- Max of 'a' and 'b'.
		do
			Result := a
			if a < b then
				Result := b
			end
		end

end
