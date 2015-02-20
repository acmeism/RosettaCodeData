class
	COUNTING_SORT
feature
sort(ar: ARRAY[INTEGER]; min, max: INTEGER): ARRAY[INTEGER]
	local
		count: ARRAY[INTEGER]
		i, j, z: INTEGER
	do
		create count.make_filled (0, 0, max-min)
		from
			i:= 0
		until
			i= ar.count
		loop
			count[ar[i]-min]:= count[ar[i]-min]+1
			i:= i+1
		end
		across count as c loop io.put_string (c.item.out + "%T")  end
		z:= 0
		from i:= min
		until i>max
		loop
			from j:= 0
			until j= count[i-min]
			loop
				ar[z]:=i
				z:= z+1
				j:= j+1
			end
			i:= i+1
		end
		Result:= ar
	end
end
