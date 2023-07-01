class
	RANDOMIZER

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		local
			time: TIME
		do
			sequence.do_nothing
		end

feature -- Access

	random_integer_in_range (a_range: INTEGER_INTERVAL): INTEGER
		do
			Result := (sequence.double_i_th (1) * a_range.upper).truncated_to_integer + a_range.lower
		end

feature {NONE} -- Implementation

	sequence: RANDOM
		local
			seed: INTEGER_32
			time: TIME
		once
			create time.make_now
			seed := time.hour *
					(60 + time.minute) *
					(60 + time.second) *
					(1000 + time.milli_second)
			create Result.set_seed (seed)
		end

end
