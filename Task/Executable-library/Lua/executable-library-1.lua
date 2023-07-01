#!/usr/bin/env luajit
bit32=bit32 or bit
local lib={
	hailstone=function(n)
		local seq={n}
		while n>1 do
			n=bit32.band(n,1)==1 and 3*n+1 or n/2
			seq[#seq+1]=n
		end
		return seq
	end
}

if arg[0] and arg[0]:match("hailstone.lua") then
	local function printf(fmt, ...) io.write(string.format(fmt, ...)) end
	local seq=lib.hailstone(27)
	printf("27 has %d numbers in sequence:\n",#seq)
	for _,i in ipairs(seq) do
		printf("%d ", i)
	end
	printf("\n")
else
	return lib
end
