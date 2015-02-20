class
	APPLICATION
inherit
	ARGUMENTS
create
	make
feature {NONE} -- Initialization

	make
		do
			fizzbuzz
		end

	fizzbuzz
	local
		i: INTEGER
	do
		from
			i:= 1
		until
			i>100
		loop
			if i\\15= 0 then
				io.put_string ("FIZZBUZZ%N")
			elseif i\\3=0 then
				io.put_string ("FIZZ%N")
			elseif i\\5=0  then
				io.put_string ("BUZZ%N")
			else
				io.put_string (i.out + "%N")
			end
			i:= i+1
		end
	end
end
