class
	RC_SORT_STRING_LETTERS_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	rc_sort_string_letters_test
			-- Test {SORT_STRING_LETTERS}.
		note
			testing:
				"covers/{SORT_STRING_LETTERS}",
				"execution/isolated",
				"execution/serial"
		do
			assert_strings_equal ("sorted", now_is_string, item.sort_string ("Now is the time for all good men to come to the aid of their country."))
		end

feature {NONE} -- Test Support

	now_is_string: STRING = "[
.Naaccddeeeeeeffghhhiiiillmmmnnooooooooorrrstttttttuwy
]"

	item: SORT_STRING_LETTERS
			-- An `item' for testing.
		once
			create Result
		end

end
