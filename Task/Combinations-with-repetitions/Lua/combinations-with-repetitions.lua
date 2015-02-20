function GenerateCombinations(tList, nMaxElements, tOutput, nStartIndex, nChosen, tCurrentCombination)
	if not nStartIndex then
		nStartIndex = 1
	end
	if not nChosen then
		nChosen = 0
	end
	if not tOutput then
		tOutput = {}
	end
	if not tCurrentCombination then
		tCurrentCombination = {}
	end
	
	if nChosen == nMaxElements then
		-- Must copy the table to avoid all elements referring to a single reference
		local tCombination = {}
		for k,v in pairs(tCurrentCombination) do
			tCombination[k] = v
		end
		
		table.insert(tOutput, tCombination)
		return
	end

 	local nIndex = 1
	for k,v in pairs(tList) do
		if nIndex >= nStartIndex then
			tCurrentCombination[nChosen + 1] = tList[nIndex]
			GenerateCombinations(tList, nMaxElements, tOutput, nIndex, nChosen + 1, tCurrentCombination)
		end
		
		nIndex = nIndex + 1
	end
	
	return tOutput
end

tDonuts = {"iced", "jam", "plain"}
tCombinations = GenerateCombinations(tDonuts, #tDonuts)
for nCombination,tCombination in ipairs(tCombinations) do
	print("Combination " .. tostring(nCombination))
	for nIndex,strFlavor in ipairs(tCombination) do
		print("+" .. strFlavor)
	end
end
