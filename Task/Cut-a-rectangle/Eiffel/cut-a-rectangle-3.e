class
	POINT

create
	make, make_with_values



feature

	make_with_values (a_x: INTEGER; a_y: INTEGER)
	-- Initialize x and y with 'a_x' and 'a_y'.
		do
			x := a_x
			y := a_y
		end

	make
	-- Initialize x and y with 0.
		do
			x := 0
			y := 0
		end

	x: INTEGER

	y: INTEGER

	negative: BOOLEAN
			-- Are x or y negative?
		do
			Result := x < 0 or y < 0
		end

	same (other: POINT): BOOLEAN
			-- Does x and y equal 'other's x and y?
		do
			Result := (x = other.x) and (y = other.y)
		end

	valid: BOOLEAN
			-- Are x and y valid points?
		do
			Result := (x > 0) and (y > 0)
		end

end
