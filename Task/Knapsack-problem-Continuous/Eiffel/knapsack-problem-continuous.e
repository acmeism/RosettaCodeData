class
	CONTINUOUS_KNAPSACK

create
	make

feature

	make
		local
			tup: TUPLE [name: STRING; weight: REAL_64; price: REAL_64]
		do
			create tup
			create items.make_filled (tup, 1, 9)
			create sorted.make
			sorted.extend (-36.0 / 3.8)
			sorted.extend (-43.0 / 5.4)
			sorted.extend (-90.0 / 3.6)
			sorted.extend (-45.0 / 2.4)
			sorted.extend (-30.0 / 4.0)
			sorted.extend (-56.0 / 2.5)
			sorted.extend (-67.0 / 3.7)
			sorted.extend (-95.0 / 3.0)
			sorted.extend (-98.0 / 5.9)
			tup := ["beef", 3.8, 36.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["pork", 5.4, 43.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["ham", 3.6, 90.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["greaves", 2.4, 45.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["flitch", 4.0, 30.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["brawn", 2.5, 56.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["welt", 3.7, 67.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["salami", 3.0, 95.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			tup := ["sausage", 5.9, 98.0]
			items [sorted.index_of (- tup.price / tup.weight, 1)] := tup
			find_solution
		end

	find_solution
			-- Solution for the continuous Knapsack Problem.
		local
			maxW, value: REAL_64
		do
			maxW := 15
			across
				items as c
			loop
				if maxW - c.item.weight > 0 then
					io.put_string ("Take all: " + c.item.name + ".%N")
					value := value + c.item.price
					maxW := maxW - c.item.weight
				elseif maxW /= 0 then
					io.put_string ("Take " + maxW.truncated_to_real.out + " kg off " + c.item.name + ".%N")
					io.put_string ("The total value is " + (value + (c.item.price / c.item.weight) * maxW).truncated_to_real.out + ".")
					maxW := 0
				end
			end
		end

	items: ARRAY [TUPLE [name: STRING; weight: REAL_64; price: REAL_64]]

	sorted: SORTED_TWO_WAY_LIST [REAL_64]

end
