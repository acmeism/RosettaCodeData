local Format = string.format
local tonumber = tonumber
local ipairs = ipairs
local Rep = string.rep

-- there is no | so this is the best we can do in pure lua patt
local ipv4_addr_patt = "[12]?%d?%d%.[12]?%d?%d%.[12]?%d?%d%.[12]?%d?%d"
local ipv4_patt = "^(" .. ipv4_addr_patt .. "):?(%d*)$"

-- ipv4 -> addr?, port?
local V4Parse = function (ipv4)
	local addr, port = ipv4:match(ipv4_patt)
	if addr then
	  for digitS in addr:gmatch"%d+" do
      if tonumber(digitS)>255 then return nil end
    end
  end
  return addr, port
end

-- no check
local V4ToHex = function (ipv4_addr)
	local hex = Format(
		"%.2x%.2x%.2x%.2x"
		, ipv4_addr:match"^(%d+)%.(%d+)%.(%d+)%.(%d+)$"
	)
	return hex, tonumber("0x" .. hex)
end

-- ipv4_address -> addr?, port?, hex?
local V4 = function (ipv4) -- "address:port" -> address:str|nil, port:str|nil, hex:str|nil
	local addr, port = V4Parse(ipv4)
	if addr then
		return addr, port, V4ToHex(addr)
	end
	return nil
end

--------------------------------- IPV6 Section
local ipv6_patternsT do
	local v6 = "([%x:]*:[%x:]*:[%x:]*)"
	local v64 = "([%x:]*:[%x:]*:" .. ipv4_addr_patt .. ")"

	ipv6_patternsT = { -- these are guessers/approximators
	 -- [addr]
	  "^%[" .. v6 .. "%]:(%d+)$" -- [v6]:port
	  ,"^%[" .. v6 .. "%]$" -- [v6]
	  ,"^%[" .. v64 .. "%]:(%d+)$" -- [v6+v4]:port
	  ,"^%[" .. v64 .. "%]$" -- [v6+v4]

	 -- guesswork
	  ,"^" .. v64 .. ":(%d+)$" -- v6+v4+port
		-- TODO: unsure if v6+v4[#p:.]port is valid

	  ,"^(" .. v64 .. ")$" -- v6+v4

	  ,"^" .. v6 .. "[.p#](%d+)$" -- v6+port
			-- portsep=":" handled bellow
			-- There is no way to use port while using : as the port separator
			-- the only method is if its complete or if its :::80
		  , "^([%x:]*::):(%d+)$" -- v6+port
			-- Complete
		  ,"^(" .. ("%x*:"):rep(7) .. "%x*):(%d+)$" -- v6+port

	  ,"^" .. v6 .. "$" -- v6
	}
end

-- addr, port -- nil if failure
-- addr will be returned as
-- ipv6_address port -> address, port, mini hexified address (no ipv4)
local V6Parse = function (ipv6_address)
	-- get the port, then get the ip via position
	for _,match in ipairs(ipv6_patternsT) do
		local address, port = ipv6_address:match(match)
		if address then
			local addr = address -- addr is going to be in ipv6 hex (no ipv4)
			if -- valid ipv6 address?
--				select(2, addr:gsub(":",""))==1 -- this shouldn't happen
				-- 2 ::
				addr:match"::.+::"
				-- 3 :::
				or addr:match":::"
				-- 4 %x per non [^:] ONLY
				or addr:match"%x%x%x%x%x"
			then
				return nil
			end
			local v6,v4 = addr:match("^([%x:]+:)(%d+%.%d+%.%d+%.%d+)$")
			if v4 and V4Parse(v4) then
				addr = Format("%s%s:%s", v6, V4ToHex(v4):match"^(....)(....)$")
			end
			if addr:gsub(":", "", 7):match":" then return nil end
			return address, port, addr
		end
	end
	return nil, nil
end

-- Returns ipv6 address filled (0:0:0:0:0) instead of ::
local V6Fill = function (addr) -- addr must be hexified
-- fill ::
	if addr:match"::" then
		local _, count = addr:gsub(":+","")
		addr = addr:gsub("::"
			,(addr:match"^::" and "0000:" or ":")
				.. Rep("0", 8-count,":")
		  ,1
		)
	end

-- fill 0
	addr = addr:gsub("[^:]+"
		,function (section)
			return Format("%.4x",tonumber("0x" .. section))
		end
	)

	return addr
end

-- cannot return num after fff:ffff:ffff:ffff
-- this is dependant on tonumber() itself
local V6ToHex = function (addr)
	local ipv6 = V6Fill(addr)
	local hex = ipv6:gsub(":","")
	local num do -- tonumber fails after 3:
		local x = hex:gsub("^0+", "")
		if #x<=15 then
			num = x=="" and 0 or tonumber("0x" .. x)
		end
	end
	return hex, num or -1, ipv6 -- cannot tonumber hex too big
end

-- ipv6_address -> addr?, port?, hex?
local V6 = function (address)
	local addr, port, ipv6 = V6Parse(address)
	if addr then
		return addr, port, V6ToHex(ipv6)
	end
	return addr, port
end

local IpToHex = function (address)
	if address:match(ipv4_patt) then
		return 4, V4(address)
	end
	return 6, V6(address)
end

for _, addr in ipairs{
 "127.0.0.1", "127.0.0.1:80", "::1", "[::1]:80",
 "2605:2700:0:3::4713:93e3",
 "[2605:2700:0:3::4713:93e3]:80"
} do
    print(IpToHex(addr))
end
