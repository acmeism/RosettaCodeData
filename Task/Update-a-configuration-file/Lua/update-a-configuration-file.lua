local function Read(handler) -- NR, line, comment, option, parameters
	local line = handler:read"l"
	if line==nil or line=="" or line:sub(1,1)=="#" or line:find"^;?%s*$"
	then
		return line,nil,nil,true
	end
	local comment, option, param = line:match"^(;?)%s*(%S*)%s*(.*)$"
	comment = comment==";"
	if not comment then
		param = param=="" and true or tonumber(param) or param
	end
	return line, option, param, comment
end

local function LoadConfig(H)
	local options = {}
	for line, option, param, comment in Read,H do
		if not comment and option then
			options[option] = param
		end
	end
	H:close()
	return options
end

local function MakeLine(k,v)
	return v==false and "; " .. k
		or v==true and k
		or v and k .. " " .. v
end

local function Sponge(fileS)
	local H, tmp = io.open(fileS), io.tmpfile()
	tmp:write(H:read"a") tmp:seek"set"
	H:close()
	return tmp
end

local function Update(fileS, options)
	local IN = Sponge(fileS)
	local nl = string.match(IN:read"L" or "\n", "[\r\n]?\n$") IN:seek"set"
	local OUT = io.open(fileS, "w+")
	local saved = {} -- for appending after
	for line, option, param, comment in Read,IN do
		if option then
			local val = options[option]
			saved[option] = true
			if val~=param then
				line = MakeLine(option,val)
			end
		end
		OUT:write(line, nl)
	end
	IN:close()
	for k,v in pairs(options) do
		if saved[k]==nil then
			OUT:write( MakeLine(k,v), nl )
		end
	end
	OUT:close()
end

local options = LoadConfig( io.open(arg[1]) )

-- nil would remove the option entirely
options.NEEDSPEELING = false -- disable
options.SEEDSREMOVED = true
options.NUMBEROFBANANAS = 1024
options.NUMBEROFSTRAWBERRIES = 62000

Update(arg[1], options)
