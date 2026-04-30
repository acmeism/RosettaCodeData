for line in io.lines"input.txt" do
	local this = {}
	for word in line:gmatch("%S+") do
		table.insert(this, 1, word)
	end
	print( table.concat(this, " ") )
end
