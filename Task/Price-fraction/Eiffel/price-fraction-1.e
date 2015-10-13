class
	APPLICATION

create
	make

feature

	make
			--Tests the price_adjusted feature.
		local
			i: REAL
		do
			create price_fraction.initialize
			from
				i := 5
			until
				i = 100
			loop
				io.put_string ("Given: ")
				io.put_real (i / 100)
				io.put_string ("%TAdjusted:")
				io.put_real (price_fraction.adjusted_price (i / 100))
				io.new_line
				i := i + 5
			end
		end

	price_fraction: PRICE_FRACTION

end
