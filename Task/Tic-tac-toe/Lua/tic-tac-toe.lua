#!/usr/bin/env luajit
ffi=require"ffi"
local function printf(fmt,...) io.write(string.format(fmt, ...)) end
local board="123456789" -- board
local pval={1, -1}      -- player 1=1 2=-1 for negamax
local pnum={} for k,v in ipairs(pval) do pnum[v]=k end
local symbol={'X','O'}  -- default symbols X and O
local isymbol={} for k,v in pairs(symbol) do isymbol[v]=pval[k] end
math.randomseed(os.time()^5*os.clock()) -- time-seed the random gen
local random=math.random
-- usage of ffi variables give 20% speed
ffi.cdef[[
	typedef struct{
		char value;
		char flag;
		int depth;
	}cData;
]]
-- draw the "board" in the way the numpad is organized
local function draw(board)
	for i=7,1,-3 do
		print(board:sub(i,i+2))
	end
end
-- pattern for win situations
local check={"(.)...%1...%1","..(.).%1.%1..",
	"(.)%1%1......","...(.)%1%1...","......(.)%1%1",
	"(.)..%1..%1..",".(.)..%1..%1.","..(.)..%1..%1",
}
-- calculate a win situation for which player or draw
local function win(b)
	local sub
	for i=1,#check do
		sub=b:match(check[i])
		if sub then break end
	end
	sub=isymbol[sub]
	return sub or 0
end
-- input only validate moves of not yet filled positions
local function input(b,player)
	char=symbol[pnum[player]]
	local inp
	repeat
		printf("Player %d (\"%s\") move: ",pnum[player],char)
		inp=tonumber(io.read()) or 0
	until inp>=1 and inp<=9 and b:find(inp)
	b=b:gsub(inp,char)
	return b,inp
end
-- ask how many human or AI players
local function playerselect()
	local ai={}
	local yn
	for i=1,2 do
		repeat
			printf("Player %d human (Y/n)? ", i) yn=io.read():lower()
		until yn:match("[yn]") or yn==''
		if yn=='n' then
			ai[pval[i]]=true
			printf("Player %d is AI\n", i)
		else
			printf("Player %d is human\n", i)
		end
	end
	return ai
end
local function endgame()
	repeat
		printf("\nEnd game? (y/n)? ", i) yn=io.read():lower()
	until yn:match("[yn]")
	if yn=='n' then
		return false
	else
		printf("\nGOOD BYE PROFESSOR FALKEN.\n\nA STRANGE GAME.\nTHE ONLY WINNING MOVE IS\nNOT TO PLAY.\n\nHOW ABOUT A NICE GAME OF CHESS?\n")
		return true
	end
end
-- AI Routine
local function shuffle(t)
	for i=#t,1,-1 do
		local rnd=random(i)
		t[i], t[rnd] = t[rnd], t[i]
	end
	return t
end
-- move generator
local function genmove(node, color)
	return coroutine.wrap(function()
		local moves={}
		for m in node:gmatch("%d") do
			moves[#moves+1]=m
		end
		shuffle(moves) -- to make it more interesting
		for _,m in ipairs(moves) do
			local child=node:gsub(m,symbol[pnum[color]])
			coroutine.yield(child, m)
		end
	end)
end
--[[
Negamax with alpha-beta pruning and table caching
]]
local cache={}
local best, aimove, tDepth
local LOWERB,EXACT,UPPERB=-1,0,1 -- has somebody an idea how to make them real constants?
local function negamax(node, depth, color, α, β)
	color=color or 1
	α=α or -math.huge
	β=β or math.huge
	-- check for cached node
	local αOrg=α
	local cData=cache[node]
	if cData and cData.depth>=depth and depth~=tDepth then
		if cData.flag==EXACT then
			return cData.value
		elseif cData.flag==LOWERB then
			α=math.max(α,cData.value)
		elseif cData.flag==UPPERB then
			β=math.min(β,cData.value)
		end
		if α>=β then
			return cData.value
		end
	end

	local winner=win(node)
	if depth==0 or winner~=0 then
		return winner*color
	end
	local value=-math.huge
	for child,move in genmove(node, color) do
		value=math.max(value, -negamax(child, depth-1, -color, -β, -α))
		if value>α then
			α=value
			if depth==tDepth then
				best=child
				aimove=move
			end
		end
		if α>=β then break end
	end
	-- cache known data
	--cData={}  -- if you want Lua tables instead of ffi you can switch the two lines here, costs 20% speed
	cData=ffi.new("cData")
	cData.value=value
	if value<=αOrg then
		cData.flag=UPPERB
	elseif value>=β then
		cData.flag=LOWERB
	else
		cData.flag=EXACT
	end
	cData.depth=depth
	cache[node]=cData
	return α
end
-- MAIN
do
	local winner,value
	local score={[-1]=0, [0]=0, [1]=0}
	repeat
		print("\n   TIC-TAC-TOE\n")
		local aiplayer=playerselect()
		local player=1
		board="123456789"
		for i=1,#board do
			draw(board)
			tDepth=10-i
			if aiplayer[player] then
				negamax(board, tDepth, player, -math.huge, math.huge)
				board=best
				printf("AI %d moves %s\n", pnum[player], aimove)
			else
				board=input(board,player)
			end
			winner=win(board)
			if winner~=0 then break end
			player=-player
		end
		score[winner]=score[winner]+1
		if winner and winner~=0 then
			printf("*** Player %d (%s) has won\n", pnum[winner], symbol[pnum[winner]])
		else
			printf("*** No winner\n")
		end
		printf("Score Player 1: %d Player 2: %d Draw: %d\n",score[1],score[-1],score[0])
		draw(board)
	until endgame()
end
