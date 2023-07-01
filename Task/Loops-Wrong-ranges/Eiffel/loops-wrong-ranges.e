example
		-- Loops/Wrong ranges
	do
		⟳ ic:(-2 |..| 2) ¦ 				do_nothing ⟲ --  2 	2 	 1 	Normal
		⟳ ic:(-2 |..| 2).new_cursor + 0 ¦ 		do_nothing ⟲ -- -2 	2 	 0 	Zero increment
		⟳ ic:(-2 |..| 2).new_cursor - 1 ¦ 		do_nothing ⟲ -- -2 	2 	-1 	Increments away from stop value
		⟳ ic:(-2 |..| 2).new_cursor + 10 ¦ 		do_nothing ⟲ -- -2 	2 	10 	First increment is beyond stop value
		⟳ ic:(-2 |..| 2).new_cursor.reversed ¦ 		do_nothing ⟲ --  2 	-2 	 1 	Start more than stop: positive increment
		⟳ ic:(2 |..| 2) ¦ 				do_nothing ⟲ --  2 	2 	 1 	Start equal stop: positive increment
		⟳ ic:(2 |..| 2).new_cursor - 1 ¦ 		do_nothing ⟲ --  2 	2 	-1 	Start equal stop: negative increment
		⟳ ic:(2 |..| 2).new_cursor + 0 ¦ 		do_nothing ⟲ --  2 	2 	 0 	Start equal stop: zero increment
		⟳ ic:(0 |..| 0).new_cursor + 0 ¦ 		do_nothing ⟲ --  0 	0 	 0 	Start equal stop equal zero: zero increment
	end
