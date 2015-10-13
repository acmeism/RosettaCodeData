	output_lyrics
			-- Output the lyrics to 99-bottles-of-beer.
		local
			l_bottles: LINKED_LIST [INTEGER]
		do
			create l_bottles.make
			across (1 |..| 99) as ic loop l_bottles.force (ic.item) end
			across l_bottles.new_cursor.reversed as ic_bottles loop
				print (ic_bottles.item)
				print (" bottles of beer on the wall, ")
				print (ic_bottles.item)
				print (" bottles of beer.%N")
				print ("Take one down, pass it around, ")
				if ic_bottles.item > 1 then
					print (ic_bottles.item)
					print (" bottles of beer on the wall.%N%N")
				end
			end
			print ("1 bottle of beer on the wall.%N")
			print ("No more bottles of beer on the wall, no more bottles of beer.%N")
			print ("Go to the store and buy some more, 99 bottles of beer on the wall.%N")
		end
