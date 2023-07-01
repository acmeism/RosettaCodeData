local function escapeForPattern(str)
	return (str:gsub("[-+*^?$.%%()[%]]", "%%%0"))
end

local function toCamelCase(str, separator)
	local escapedSeparator = escapeForPattern(separator)
	local namePattern      = "%l%w*"..escapedSeparator.."[%w"..escapedSeparator.."]*%w" -- Starting with a lower case character and containing the separator character.
	local separatorPattern = escapedSeparator.."(%w)" -- Discard the separator and capture the alphanumeric character.

	return (str:gsub(namePattern, function(name)
		return (name:gsub(separatorPattern, string.upper)) -- The captured character will be the one argument for string.upper().
	end))
end

local function fromCamelCase(str, separator)
	local namePattern       = "%l+[%u%d]%w*" -- Starting with a lower case character and containing an upper case character or digit.
	local separatorPattern1 = "(%l)([%u%d])" -- Lower case character followed by upper case character or digit.
	local separatorPattern2 = "(%d)(%a)"     -- Digit followed by alphanumeric character.

	return (str:gsub(namePattern, function(name)
		return (name
			:gsub(separatorPattern1, function(char1,char2)  return char1..separator..char2:lower()  end)
			:gsub(separatorPattern2, function(char1,char2)  return char1..separator..char2:lower()  end)
		)
	end))
end
