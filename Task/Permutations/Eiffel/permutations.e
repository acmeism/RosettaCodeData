permute(a: ARRAY[INTEGER]; k: INTEGER)
	require
		 ar_not_void: a.count>=1
		 k_valid_index: k>0
	local
		i,t: INTEGER
	do
	if k=a.count then
		across a as ar loop io.put_string (ar.item.out)  end
		io.put_string ("%N")
	else
		from
			i:= k
		until
			i> a.count
		loop
			t:= a[k]
			a[k]:= a[i]
			a[i]:= t
			permute(a,k+1)
			t:= a[k]
			a[k]:= a[i]
			a[i]:= t
			i:= i+1
		end
	end
make
	do
			test:= << 2,5,1>>
			permute(test, 1)
	end
	test: ARRAY[INTEGER]

end
