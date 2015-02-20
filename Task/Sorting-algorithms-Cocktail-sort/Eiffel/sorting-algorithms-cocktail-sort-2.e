class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
		test:= <<5,1,99,3,2>>
		across test as t  loop io.put_string (t.item.out + "%T")  end
		create cs
                test:= cs.cocktail_sort(test)
		across test as ar loop io.put_string (ar.item.out+"%T")  end
	end
	cs: COCKTAIL_SORT[INTEGER]
	test: ARRAY[INTEGER]
end
