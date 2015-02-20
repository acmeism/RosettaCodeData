class
	PANCAKE_SORT
create
	make
feature{NONE}
    arraymax(array: ARRAY [INTEGER]; upper: INTEGER):INTEGER
        require
		upper_index_positive: upper >=0
		array_exists: array/= void
        local
                i, cur_max, index: INTEGER
        do
                from
                        i:=1
                        cur_max := array.item (i)
                        index := i
                until
                        i+1 > upper
                loop
                        if  array.item(i+1) > cur_max then
                                cur_max := array.item(i+1)
                                index := i+1
                        end
                        i := i + 1
                end
                Result:=index
        ensure
       		Index_positive: Result > 0
        end

    reverse_array(ar:ARRAY[INTEGER]; upper:INTEGER):ARRAY[INTEGER]
        require
    		upper_positive: upper >0
    		ar_not_void: ar /= void
    	local
    		i,j:INTEGER
    		new_array: ARRAY[INTEGER]
    	do
    		create new_array.make_empty
			new_array.copy (ar)
			from
				i:= 1
				j:=upper
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

   sort(ar:ARRAY[INTEGER]):ARRAY[INTEGER]
    	local
    		i:INTEGER
    	do
    		my_array:=ar
		from
			i:=ar.count
		until
			i=1
		loop
			my_array:=reverse_array(reverse_array(my_array, arraymax(my_array,i)),i)
			i:=i-1
		end
    		Result := my_array
        ensure
    		same_length: ar.count= Result.count
    	end

    my_array:ARRAY[INTEGER]

feature
    make(ar:ARRAY[INTEGER])
    	do
    		create my_array.make_from_array(ar)
    	end

    pancake_sort:ARRAY[INTEGER]
    	do
    		Result:= sort(my_array)
    	end
end
