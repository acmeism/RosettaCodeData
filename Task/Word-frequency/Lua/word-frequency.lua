-- This program takes two optional command line arguments.  The first (arg[1])
-- specifies the input file, or defaults to standard input.  The second
-- (arg[2]) specifies the number of results to show, or defaults to 10.

-- in freq, each key is a word and each value is its count
local freq = {}
for line in io.lines(arg[1]) do
	-- %a stands for any letter
	for word in string.gmatch(string.lower(line), "%a+") do
		if not freq[word] then
			freq[word] = 1
		else
			freq[word] = freq[word] + 1
		end
	end
end

-- in array, each entry is an array whose first value is the count and whose
-- second value is the word
local array = {}
for word, count in pairs(freq) do
	table.insert(array, {count, word})
end
table.sort(array, function (a, b) return a[1] > b[1] end)

for i = 1, arg[2] or 10 do
	io.write(string.format('%7d %s\n', array[i][1] , array[i][2]))
end
