#!/usr/bin/env luajit
local function printf(fmt, ...) io.write(string.format(fmt, ...)) end
local runs=0
local function move(tower, from, to)
	if #tower[from]==0
		or (#tower[to]>0
		and tower[from][#tower[from]]>tower[to][#tower[to]]) then
			to,from=from,to
	end
	if #tower[from]>0 then
		tower[to][#tower[to]+1]=tower[from][#tower[from]]
		tower[from][#tower[from]]=nil

		io.write(tower[to][#tower[to]],":",from, "→", to, " ")
	end
end

local function hanoi(n)
	local src,dst,via={},{},{}
	local tower={src,dst,via}
	for i=1,n do src[i]=n-i+1 end
	local one,nxt,lst
	if n%2==1 then -- odd
		one,nxt,lst=1,2,3
	else
		one,nxt,lst=1,3,2
	end
	--repeat
	::loop::
		move(tower, one, nxt)
		if #dst==n then return end
		move(tower, one, lst)
		one,nxt,lst=nxt,lst,one
	goto loop
	--until false
end

local num=arg[1] and tonumber(arg[1]) or 4

hanoi(num)
