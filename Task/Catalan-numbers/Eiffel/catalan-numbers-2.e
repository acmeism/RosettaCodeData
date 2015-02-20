class
	APPLICATION
inherit
	ARGUMENTS
create
	make
feature {NONE} -- Initialization
	make
	local
		s: STRING
		do
			create cat
			from
				i:=0
			until
				i>14
			loop
				io.put_double (cat.cat_num (i))
				io.put_string ("%N")
				i:= i+1
			end
		end
	cat: CATALAN_NUMBERS
end
