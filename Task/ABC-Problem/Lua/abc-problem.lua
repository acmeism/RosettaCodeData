blocks = {
	{"B","O"};	{"X","K"};	{"D","Q"};	{"C","P"};
	{"N","A"};	{"G","T"};	{"R","E"};	{"T","G"};
	{"Q","D"};	{"F","S"};	{"J","W"};	{"H","U"};
	{"V","I"};	{"A","N"};	{"O","B"};	{"E","R"};
	{"F","S"};	{"L","Y"};	{"P","C"};	{"Z","M"};
	};

function canUse(table, letter)
	for i,v in pairs(blocks) do
		if (v[1] == letter:upper() or v[2] == letter:upper())  and table[i] then
			table[i] = false;
			return true;
		end
	end
	return false;
end

function canMake(Word)
	local Taken = {};
	for i,v in pairs(blocks) do
		table.insert(Taken,true);
	end
	local found = true;
	for i = 1,#Word do
		if not canUse(Taken,Word:sub(i,i)) then
			found = false;
		end
	end
	print(found)
end
