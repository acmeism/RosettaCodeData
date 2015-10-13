class
	KNAPSACK

create
	make

feature

	make
		do
			create panacea;
			panacea := [3000, 0.3, 0.025]
			create ichor;
			ichor := [1800, 0.2, 0.015]
			create gold;
			gold := [2500, 2.0, 0.002]
			create sack;
			sack := [0, 25.0, 0.25]
			find_solution
		end

feature {NONE}

	panacea: TUPLE [value: INTEGER; weight: REAL_64; volume: REAL_64]

	ichor: TUPLE [value: INTEGER; weight: REAL_64; volume: REAL_64]

	gold: TUPLE [value: INTEGER; weight: REAL_64; volume: REAL_64]

	sack: TUPLE [value: INTEGER; weight: REAL_64; volume: REAL_64]

	find_solution
			-- Solution for unbounded Knapsack Problem.
		local
			totalweight, totalvolume: REAL_64
			maxpanacea, maxichor, maxvalue, maxgold: INTEGER
			n: ARRAY [INTEGER]
			r: TUPLE [value: INTEGER; weight: REAL_64; volume: REAL_64]
		do
			maxpanacea := minimum (sack.weight / panacea.weight, sack.volume / panacea.volume).rounded
			maxichor := minimum (sack.weight / ichor.weight, sack.volume / ichor.volume).rounded
			maxgold := minimum (sack.weight / gold.weight, sack.volume / gold.volume).rounded
			create n.make_filled (0, 1, 3)
			create r
			across
				0 |..| maxpanacea as p
			loop
				across
					0 |..| maxichor as i
				loop
					across
						0 |..| maxgold as g
					loop
						r.value := g.item * gold.value + i.item * ichor.value + p.item * panacea.value
						r.weight := g.item * gold.weight + i.item * ichor.weight + p.item * panacea.weight
						r.volume := g.item * gold.volume + i.item * ichor.volume + p.item * panacea.volume
						if r.value > maxvalue and r.weight <= sack.weight and r.volume <= sack.volume then
							maxvalue := r.value
							totalweight := r.weight
							totalvolume := r.volume
							n [1] := p.item
							n [2] := i.item
							n [3] := g.item
						end
					end
				end
			end
			io.put_string ("Maximum value achievable is " + maxValue.out + ".%N")
			io.put_string ("This is achieved by carrying " + n [1].out + " panacea, " + n [2].out + " ichor and " + n [3].out + " gold.%N")
			io.put_string ("The weight is " + totalweight.out + " and the volume is " + totalvolume.truncated_to_real.out + ".")
		end

	minimum (a, b: REAL_64): REAL_64
			-- Smaller of 'a' and 'b'.
		do
			Result := a
			if a > b then
				Result := b
			end
		end

end
