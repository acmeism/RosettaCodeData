class
	PRICE_FRACTION

create
	initialize

feature

	initialize
			-- Initializes limit and price to the given values.
		do
			limit := <<0.06, 0.11, 0.16, 0.21, 0.26, 0.31, 0.36, 0.41, 0.46, 0.51, 0.56, 0.61, 0.66, 0.71, 0.76, 0.81, 0.86, 0.91, 0.96, 1.01>>
			price := <<0.10, 0.18, 0.26, 0.32, 0.38, 0.44, 0.50, 0.54, 0.58, 0.62, 0.66, 0.70, 0.74, 0.78, 0.81, 0.86, 0.90, 0.94, 0.98, 1.00>>
		end

	adjusted_price (n: REAL): REAL
			-- Adjusted price according to the given price values.
		local
			i: INTEGER
			found: BOOLEAN
		do
			from
				i := 1
			until
				i > limit.count or found
			loop
				if n <= limit [i] then
					Result := (price [i])
					found := True
				end
				i := i + 1
			end
		end

feature {NONE}

	limit: ARRAY [REAL]

	price: ARRAY [REAL]

end
