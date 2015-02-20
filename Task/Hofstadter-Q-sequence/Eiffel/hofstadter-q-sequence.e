class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	local
		count,i: INTEGER
	do
		io.put_string ("%NFirst ten numbers: %N")
	        test:=seq (10)
		across test as ar loop io.put_string (ar.item.out + "%T") end
		test:= seq (100000)
 		io.put_string ("1000th:%N")
 		io.put_integer (test[1000])
		io.put_string ("%NNumber of Flips:%N")
		from i:=2
		until i>100000
		loop
			if test[i ]< test[i-1] then
				count:= count+1
			end
			i:= i+1
		end
		io.put_integer (count)
        end
	test: ARRAY[INTEGER]

	seq(lim: INTEGER): ARRAY[INTEGER]
		require
			lim_positive: lim>0
		local
			q: ARRAY[INTEGER]
			i: INTEGER
		do
			create q.make_filled(1, 1, lim)
			q[1]:= 1
			q[2]:= 1
			from
				i:= 3
			until
				i> lim
			loop
				q[i]:= q[i-q[i-1]]+q[i-q[i-2]]
				i:= i+1
			end
			Result:= q
		end
end
