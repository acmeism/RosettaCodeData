function encodeChar(chr)
	return string.format("%%%X",string.byte(chr))
end

function encodeString(str)
	local output, t = string.gsub(str,"[^%w]",encodeChar)
	return output
end

-- will print "http%3A%2F%2Ffoo%20bar%2F"
print(encodeString("http://foo bar/"))
