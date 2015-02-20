class
	STOOGE_SORT
feature
	stoogesort (ar: ARRAY[INTEGER]; i,j: INTEGER)
	require
		ar_not_empty: ar.count >= 0
		i_in_range: i>=1
		j_in_range: j <= ar.count
		boundary_set: i<=j
	local
		t: REAL_64
		third: INTEGER
		swap: INTEGER
	do
		if ar[j]< ar[i] then
			swap:= ar[i]
			ar[i]:=ar[j]
			ar[j]:= swap
		end
		if j-i >1 then
			t:= (j-i+1)/3
			third:= t.floor
			stoogesort(ar, i, j-third)
			stoogesort(ar, i+third, j)
			stoogesort(ar, i, j-third)
		end
	end
end
