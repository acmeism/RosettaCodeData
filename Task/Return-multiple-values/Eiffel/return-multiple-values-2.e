some_feature: TUPLE[INTEGER_32, CHARACTER_8, STRING_8]
	do
		--Result := [ ]			-- compile error	
		--Result := [1, "r", 'j']	-- also compile error	
		Result := [1, 'j', "r"]		-- okay
		Result := [1, 'j', "r", 1.23]	-- also okay
	end
