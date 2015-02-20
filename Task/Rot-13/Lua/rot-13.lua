function rot13(s)
	local a = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	local b = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"
	return (s:gsub("%a", function(c) return b:sub(a:find(c)) end))
end
