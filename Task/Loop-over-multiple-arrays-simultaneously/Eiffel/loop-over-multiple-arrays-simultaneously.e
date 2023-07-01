example (a_array: READABLE_INDEXABLE [BOUNDED [ANY]]): STRING
		-- Assemble output for a 2-dim array in `a_array'
	require
		non_zero: ∀ nzitem:a_array ¦ nzitem.count > 0
	local
		min_count: INTEGER
	do
		⟳ v_item:a_array ¦
			min_count := if min_count = 0 then
							v_item.count
						else
							v_item.count.min (min_count)
						end
		⟲
		create Result.make_empty
		⟳ j:1 |..| min_count ¦
			⟳ i:a_array ¦
				if attached {READABLE_INDEXABLE [ANY]} i as al_i then
					Result.append_string_general (al_i [j].out)
				end
			⟲
			Result.append_string_general ("%N")
		⟲
	end

input_data: ARRAY [BOUNDED [ANY]]
		-- Sample `input_data' for `example' (above).
	do
		Result := <<
						"abcde",
						"ABC",
						<<1, 2, 3, 4>>
					>>
	end
