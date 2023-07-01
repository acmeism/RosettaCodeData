feature -- Test routines

	rc_greyscale_bars_test
			-- Greyscale bars/Display
		note
			testing:
				"execution/isolated",
				"execution/serial"
		local
			y: INTEGER
		do
			y := 0
			paint_row (black, y, r1_div_count, r1_width)

			y := y + row_height
			paint_row (white, y, r2_div_count, r2_width)

			y := y + row_height
			paint_row (black, y, r3_div_count, r3_width)

			y := y + row_height
			paint_row (white, y, r4_div_count, r4_width)

			pic.save_to_named_file (create {EV_PNG_FORMAT}, ".\testing\rc_greyscale_bars\eifgreyscale.png")
		end

feature {NONE} -- Test Support

	paint_row (a_init_color: REAL; a_y, r_div, r_width: INTEGER)
			-- `paint_row' with rectangles from `black' to `white' or reverse.
		require
			valid_color: a_init_color = white or else a_init_color = black
			valid_y: (<<0,row_height * 1, row_height * 2, row_height * 3>>).has (a_y)
			valid_div: (<<r1_div_count, r2_div_count, r3_div_count, r4_div_count>>).has (r_div)
			valid_width: (<<r1_width, r2_width, r3_width, r4_width>>).has (r_width)
		local
			color: REAL
			x, dir: INTEGER
		do
			color := a_init_color
			if color = white then dir := down else dir := up end
			⟳ i:1 |..| r_div ¦
				pic.set_foreground_color (create {EV_COLOR}.make_with_rgb (color, color, color))
				pic.fill_rectangle (x, a_y, r_width, row_height)
				color := color + ((1/r_div).truncated_to_real * dir)
				x := x + r_width
			⟲
		end

feature -- Constants

	pic: EV_PIXMAP
		once
			create Result.make_with_size (width, height)
		end

	width: INTEGER = 1024
	height: INTEGER = 768

	row_height: INTEGER once Result := (height / 4).truncated_to_integer end

	r1_width: INTEGER = 128; r1_div_count: INTEGER = 8	--| width of each rectangle; number of rectangles on this row
	r2_width: INTEGER = 64; r2_div_count: INTEGER = 16
	r3_width: INTEGER = 32; r3_div_count: INTEGER = 32
	r4_width: INTEGER = 16; r4_div_count: INTEGER = 64

	black: REAL = 0.0
	white: REAL = 1.0

	down: INTEGER = -1	--| From `white' to `black' or ...
	up: INTEGER = 1		--| From `black' to `white'
