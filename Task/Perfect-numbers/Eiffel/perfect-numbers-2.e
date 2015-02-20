class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
		create perfect
		io.put_string ("%N 6 is perfect...%T")
		io.put_boolean (perfect.perfect (6))
		io.put_string ("%N77 is perfect...%T")
		io.put_boolean (perfect.perfect (77))
		io.put_string ("%N496 is perfect...%T")
		io.put_boolean (perfect.perfect (496))

	end
	perfect: PERFECT_NUMBERS
end
