class
	RC_SUBSTRING_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	rc_substring_test
			-- New test routine
		note
			task: "[
				Display a substring:

				- starting from   n   characters in and of   m   length;
				- starting from   n   characters in,   up to the end of the string;
				- whole string minus the last character;
				- starting from a known   character   within the string and of   m   length;
				- starting from a known   substring   within the string and of   m   length.
				]"
			testing:
				"execution/isolated",
				"execution/serial"
			local
				str, str2: STRING
				n, m: INTEGER
			do
				str := "abcdefgh"

				m := 2

					-- starting from   n   characters in and of   m   length;
				n := str.index_of ('e', 1)
				str2 := str.substring (n, n + m - 1)
				assert_strings_equal ("start_n", "ef", str2)
				assert_integers_equal ("m_length_1", 2, str2.count)

					-- starting from   n   characters in,   up to the end of the string;
				str2 := str.substring (n, n + (str.count - n))
				assert_strings_equal ("start_n_to_end", "efgh", str2)
				assert_integers_equal ("len_1a", 4, str2.count)

					-- whole string minus the last character;
				str2 := str.substring (1, str.count - 1)
				assert_strings_equal ("one_less_than_whole", "abcdefg", str2)
				assert_integers_equal ("len_1b", 7, str2.count)

					-- starting from a known   character   within the string and of   m   length;
				n := str.index_of ('d', 1)
				str2 := str.substring (n, n + m - 1)
				assert_strings_equal ("known_char", "de", str2)
				assert_integers_equal ("m_length_2", 2, str2.count)

					-- starting from a known   substring   within the string and of   m   length.
				n := str.substring_index ("bc", 1)
				str2 := str.substring (n, n + m - 1)
				assert_strings_equal ("known_substr", "bc", str2)
				assert_integers_equal ("m_length_3", 2, str2.count)
			end

end
