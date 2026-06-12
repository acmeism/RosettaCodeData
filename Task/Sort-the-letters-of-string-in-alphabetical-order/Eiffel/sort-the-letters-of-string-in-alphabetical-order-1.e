class
	SORT_STRING_LETTERS

feature -- Basic Ops

	sort_string (s: STRING): STRING
			-- Perform `sort_string' on `s' such that
			--	each letter is in ascending alphabetical order.
		note
			deviation: "[
				This Eiffel example deviates from the task requirement for this
				Rosetta Code task in that we reuse Eiffel Base library code for
				the {SORTED_TWO_WAY_LIST [G]}. We do this for two very good reasons:
				
				1. Reuse is king. Never code what is already coded and tested.
				2. The library code is readily available for examination
					(i.e. the library code is not hidden and unaccessible).
					
				Based on #1 and #2 above, examine the code in: {SORTED_TWO_WAY_LIST}.make_from_iterable
				Specifically, look at the `extend' routine and the routines it calls (i.e. `search_after',
				`put_left', and `back'). These routines will tell you the story of how sorting can
				be coded in Eiffel. There is no need to rehash that code here.
				]"
		local
			l_list: SORTED_TWO_WAY_LIST [CHARACTER]
		do
			create l_list.make_from_iterable (s)			-- Add & Auto-sort string by chars
			create Result.make_empty				-- Create the Result STRING
			⟳ c:l_list ¦ Result.append_character (c) ⟲		-- Populate it with the sorted chars
			Result.adjust						-- Remove the leading white space
		ensure
			no_spaces: ∀ c:Result ¦ c /= ' '			-- All spaces removed.
			has_all: ∀ c:Result ¦ s.has (c)				-- All non-space chars present.
			valid_count: Result.count =
					(s.count - s.occurrences (' '))		-- Every character (even repeating).
		end

end
