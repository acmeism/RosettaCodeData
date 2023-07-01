-- any version from LuaJIT 2.0/5.1, Lua 5.2, Lua 5.3 to LuaJIT 2.1.0-beta3-readline
local bit=bit32 or bit -- Lua 5.2/5.3 compatibilty
-- Hilbert curve implemented by Lindenmayer system
function string.hilbert(s, n)
	for i=1,n do
		s=s:gsub("[AB]",function(c)
			if c=="A" then
				c="-BF+AFA+FB-"
			else
				c="+AF-BFB-FA+"
			end
			return c
		end)
	end
	s=s:gsub("[AB]",""):gsub("%+%-",""):gsub("%-%+","")
	return s
end
-- Or the characters for ASCII line drawing
function charor(c1, c2)
	local bits={
		[" "]=0x0, ["╷"]=0x1, ["╶"]=0x2, ["┌"]=0x3, ["╵"]=0x4, ["│"]=0x5, ["└"]=0x6, ["├"]=0x7,
		["╴"]=0x8, ["┐"]=0x9, ["─"]=0xa, ["┬"]=0xb, ["┘"]=0xc, ["┤"]=0xd, ["┴"]=0xe, ["┼"]=0xf,}
	local char={" ", "╷", "╶", "┌", "╵", "│", "└", "├", "╴", "┐", "─", "┬", "┘", "┤", "┴", "┼",}
	local b1,b2=bits[c1] or 0,bits[c2] or 0
	return char[bit.bor(b1,b2)+1]
end
-- ASCII line drawing routine
function draw(s)
	local char={
		{"─","┘","╴","┐",}, -- r
		{"│","┐","╷","┌",}, -- up
		{"─","┌","╶","└",}, -- l
		{"│","└","╵","┘",},	-- down
	}
	local scr={}
	local move={{x=1,y=0},{x=0,y=1},{x=-1,y=0},{x=0,y=-1}}
	local x,y=1,1
	local minx,maxx,miny,maxy=1,1,1,1
	local dir,turn=0,0
	s=s.."F"
	local rep=0
	for c in s:gmatch(".") do
		if c=="F" then
			repeat
				if scr[y]==nil then scr[y]={} end
				scr[y][x]=charor(char[dir+1][turn%#char[1]+1],scr[y][x] or " ")
				dir = (dir+turn) % #move
				x, y = x+move[dir+1].x,y+move[dir+1].y
				maxx,maxy=math.max(maxx,x),math.max(maxy,y)
				minx,miny=math.min(minx,x),math.min(miny,y)
				turn=0
				rep=rep>1 and rep-1 or 0
			until rep==0
		elseif c=="-" then
			repeat
				turn=turn+1
				rep=rep>1 and rep-1 or 0
			until rep==0
		elseif c=="+" then
			repeat
				turn=turn-1
				rep=rep>1 and rep-1 or 0
			until rep==0
		elseif c:match("%d") then -- allow repeated commands
			rep=rep*10+tonumber(c)
		else
			repeat
				x, y = x+move[dir+1].x,y+move[dir+1].y
				maxx,maxy=math.max(maxx,x),math.max(maxy,y)
				minx,miny=math.min(minx,x),math.min(miny,y)
				rep=rep>1 and rep-1 or 0
			until rep==0
		end
	end
	for i=maxy,miny,-1 do
		local oneline={}
		for x=minx,maxx do
			oneline[1+x-minx]=scr[i] and scr[i][x] or " "
		end
		local line=table.concat(oneline)
		io.write(line, "\n")
	end
end
-- MAIN --
local n=arg[1] and tonumber(arg[1]) or 3
local str=arg[2] or "A"
draw(str:hilbert(n))
