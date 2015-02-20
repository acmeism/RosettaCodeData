class
	APPLICATION
inherit
	ARGUMENTS
create
	make

feature {NONE} -- Initialization

	make
		do
			test:= <<1,2,3,4,5,6,7>>
			io.put_string ("Initial: ")
			across test as t loop   io.put_string (t.item.out + " ") end
			create testresult.make_empty
			testresult:= shuffle (test)
			io.put_string ("%NShuffled: ")
			across testresult as t loop io.put_string (t.item.out + " ") end

		end

        test: ARRAY[INTEGER]
        testresult: ARRAY[INTEGER]

	shuffle(ar:ARRAY[INTEGER]): ARRAY[INTEGER]
	local
		i,j:INTEGER
		ith: INTEGER
		random: V_RANDOM
	do
		create random
		from
			i:=ar.count
		until
			i=2
		loop
			j:=random.bounded_item (1, i)
			ith:= ar[i]
			ar[i]:= ar[j]
			ar[j]:= ith
			random.forth
			i:=i-1
		end
		Result:= ar
	end
end
