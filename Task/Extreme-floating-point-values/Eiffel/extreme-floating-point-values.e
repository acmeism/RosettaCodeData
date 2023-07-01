class
	APPLICATION
inherit
	ARGUMENTS
create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			negInf, posInf,	negZero, nan: REAL_64
		do
			negInf := -1. / 0.	-- also {REAL_64}.negative_infinity
			posInf := 1. / 0.	-- also {REAL_64}.positive_infinity
			negZero := -1. / posInf
			nan := 0. / 0.		-- also {REAL_64}.nan

			print("Negative Infinity: ") print(negInf) print("%N")
			print("Positive Infinity: ") print(posInf) print("%N")
			print("Negative Zero: ") print(negZero) print("%N")
			print("NaN: ") print(nan) print("%N%N")

			print("1.0 + Infinity = ") print((1.0 + posInf)) print("%N")
			print("1.0 - Infinity = ") print((1.0 - posInf)) print("%N")
			print("-Infinity + Infinity = ") print((negInf + posInf)) print("%N")
			print("-0.0 * Infinity = ") print((negZero * posInf)) print("%N")
			print("NaN + NaN = ") print((nan + nan)) print("%N")
			print("(NaN = NaN) = ") print((nan = nan)) print("%N")
			print("(0.0 = -0.0) = ") print((0.0 = negZero)) print("%N")
		end
end
