#!/usr/bin/env luajit
local function ascii(f,t) local tab={} for i=f,t do tab[#tab+1]=string.char(i) end
	return table.concat(tab)
end
print(ascii(97,122))
