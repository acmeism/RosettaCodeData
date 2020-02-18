#!/usr/bin/env luajit
ffi=require"ffi"
local printf=function(fmt, ...) io.write(string.format(fmt, ...)) end
local band, bor, lshift, rshift=bit.band, bit.bor, bit.lshift, bit.rshift
local function show(x)
	for i=0,8 do
		if i%3==0 then print() end
		for j=0,8 do
			printf(j%3~=0 and "%2d" or "%3d", x[j+9*i])
		end
		print()
	end
end
local function trycell(x, pos)
	local row=math.floor(pos/9)
	local col=pos%9
	local used=0
	if pos==81 then return true end
	if x[pos]~=0 then return trycell(x, pos+1) end
	for i=0,8 do
		used=bor(used,lshift(1,x[i*9+col]-1))
	end
	for j=0,8 do
		used=bor(used,lshift(1,x[row*9+j]-1))
	end
	row=math.floor(row/3)*3
	col=math.floor(col/3)*3
	for i=row,row+2 do
		for j=col,col+2 do
			used=bor(used, lshift(1, x[i*9+j]-1))
		end
	end
	x[pos]=1
	while x[pos]<=9 do
		if band(used,1)==0 and trycell(x, pos+1) then return true end
		used=rshift(used,1)
		x[pos]=x[pos]+1
	end
	x[pos]=0
	return false
end
local function solve(str)
	local x=ffi.new("char[?]", 81)
	str=str:gsub("[%c%s]","")
	for i=0,81 do
		x[i]=tonumber(str:sub(i+1, i+1)) or 0
	end
	if trycell(x, 0) then
		show(x)
	else
		print("no solution")
	end
end

do -- MAIN
	solve([[
		5.. .7. ...
		6.. 195 ...
		.98 ... .6.

		8.. .6. ..3
		4.. 8.3 ..1
		7.. .2. ..6

		.6. ... 28.
		... 419 ..5
		... .8. .79
		]])
end
