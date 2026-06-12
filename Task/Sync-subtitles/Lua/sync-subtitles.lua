local file = arg[1]
local modify = 9 -- seconds to forward or backpedal (negative)
local repl = function (
	h, m, s, ms
)
	local seconds = modify + s + m*60 + h*60*60
	if seconds<0 then error"went too far back" end
	h, m, s = seconds/60//60, seconds//60%60, seconds%60%60
	return string.format("%.2i:%.2i:%.2i,%s", h, m, s, ms)
end

for line in io.lines(file) do
	line = line:gsub("(%d%d):(%d%d):(%d%d),(%d%d%d)", repl)
	print(line)
end

