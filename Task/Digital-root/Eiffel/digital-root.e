class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	digital_root_test_values: ARRAY [INTEGER_64]
			-- Test values.
		once
		 	Result := <<670033, 39390, 588225, 393900588225>> -- base 10
		end

	digital_root_expected_result: ARRAY [INTEGER_64]
			-- Expected result values.
		once
			Result := <<1, 6, 3, 9>> -- base 10
		end

	make
		local
			results: ARRAY [INTEGER_64]
			i: INTEGER
		do
			from
				i := 1
			until
				i > digital_root_test_values.count
			loop
				results := compute_digital_root (digital_root_test_values [i], 10)
				if results [2] ~ digital_root_expected_result [i] then
					print ("%N" + digital_root_test_values [i].out + " has additive persistence " + results [1].out + " and digital root " + results [2].out)
				else
					print ("Error in the calculation of the digital root of " + digital_root_test_values [i].out + ". Expected value: " + digital_root_expected_result [i].out + ", produced value: " + results [2].out)
				end
				i := i	+ 1
			end
		end

compute_digital_root (a_number: INTEGER_64;  a_base: INTEGER): ARRAY [INTEGER_64]
				-- Returns additive persistence and digital root of `a_number' using `a_base'.
		require
                        valid_number: a_number >= 0
                        valid_base: a_base > 1
                local
			temp_num: INTEGER_64
		do
			create Result.make_filled (0, 1, 2)
			from
				Result [2] := a_number
			until
				Result [2] < a_base
			loop
				from
					temp_num := Result [2]
					Result [2] := 0
				until
					temp_num = 0
				loop
					Result [2] := Result [2] + (temp_num \\ a_base)
					temp_num := temp_num // a_base
				end
				Result [1] := Result [1] + 1
			end
		end
