class
	APPLICATION
inherit
	ARGUMENTS
create
	make
feature {NONE} -- Initialization
make
	do
		inc("23")
	end

inc(s:STRING)
	do
	        io.put_string (s.to_integer.plus (1).out)
	end
end
