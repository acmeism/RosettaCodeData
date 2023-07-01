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
			c8: CHARACTER_8
			c32: CHARACTER_32
		do
			c8 := '%/97/'			-- using code value notation
			c8 := '%/0x61/'			-- same as above, but using hexadecimal literal
			print(c8.natural_32_code)	-- prints "97"
			print(c8)			-- prints the character "a"
			
			c32 := 'a'			-- using character literal
			print(c32.natural_32_code)	-- prints "97"
			print(c32)			-- prints "U+00000061"

			--c8 := 'π'			-- compile-time error (c8 does not have enough range)
			c32 := 'π'			-- assigns Unicode value 960
		end
end
