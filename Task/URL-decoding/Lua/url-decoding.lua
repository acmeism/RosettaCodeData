function decodeChar(hex)
	return string.char(tonumber(hex,16))
end

function decodeString(str)
	local output, t = string.gsub(str,"%%(%x%x)",decodeChar)
	return output
end

-- will print "http://foo bar/"
print(decodeString("http%3A%2F%2Ffoo%20bar%2F"))
