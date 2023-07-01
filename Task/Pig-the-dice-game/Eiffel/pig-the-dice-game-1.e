class
	PLAYER
create
	set_name
feature
	set_name(n:STRING)
		do
			name := n.twin
			set_points(0)
		end

	strategy(cur_points:INTEGER)
		local
			current_points, thrown:INTEGER
		do
			io.put_string ("You currently have " +points.out+". %NDo you want to save your points? Press y or n.%N")
			io.read_line
			if io.last_string.same_string ("y") then
				set_points(cur_points)
			else
				io.put_string ("Then throw again.%N")
				thrown:=throw_dice
				if thrown= 1 then
					io.put_string("You loose your points%N")
				else
					strategy(cur_points+thrown)
				end
			end

		end
	set_points (value:INTEGER)
		require
			value_not_neg: value >= 0
		do
			points := points + value
		end

	random: V_RANDOM
			-- Random sequence.
		once
			create Result
		end
	throw_dice: INTEGER
	        do
		        random.forth
	         	Result := random.bounded_item (1, 6)
	        end

	name: STRING
	points: INTEGER
end
