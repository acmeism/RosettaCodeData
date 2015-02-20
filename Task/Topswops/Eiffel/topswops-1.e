class
	TOPSWOPS
create
	make
feature
	make(n: INTEGER)
	local
		perm,ar:  ARRAY[INTEGER]
		i,j,k, tcount, count: INTEGER
	do
		create perm_sol.make_empty
		create solution.make_empty
		from j:= 1
		until j> n
		loop
		create ar.make_filled (0, 1, j)
		from
			k:=1
		until
			k>j
		loop
			ar[k]:=k
			k:= k+1
		end
		permute(ar, 1)
		from
			i:= 1
		until
			i> perm_sol.count
		loop
			tcount:= 0
			from

			until
				perm_sol.at (i).at (1)=1
			loop
				perm_sol.at(i):=reverse_array(perm_sol.at(i))
				tcount:= tcount+1
			end
			if tcount>count then
				count:= tcount
			end
			i:= i+1
		end
		solution.force(count, j)
		j:=j+1
		end
	end
	solution: ARRAY[INTEGER]

feature {NONE}
	perm_sol: ARRAY[ARRAY[INTEGER]]

    reverse_array(ar:ARRAY[INTEGER]):ARRAY[INTEGER]
    	require
    		ar_not_void: ar /= void
    	local
    		i,j:INTEGER
    		new_array: ARRAY[INTEGER]
    	do
    		create new_array.make_empty
    		new_array.copy(ar)
			from
				i:= 1
				j:=ar[1]
			until
				i>j
			loop
				new_array[i]:=ar[j]
				new_array[j]:=ar[i]
				i:=i+1
				j:=j-1
			end
			Result:= new_array
		ensure
			same_length: ar.count = Result.count
    	end


permute(a: ARRAY[INTEGER]; k: INTEGER)
	require
		ar_not_void: a.count>=1
		k_valid_index: k>0
	local
		i,t: INTEGER
		temp: ARRAY[INTEGER]
	do
	create temp.make_empty
	if k=a.count then
		across a as ar loop temp.force (ar.item, temp.count+1) end
		perm_sol.force(temp, perm_sol.count+1)
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
end
end
