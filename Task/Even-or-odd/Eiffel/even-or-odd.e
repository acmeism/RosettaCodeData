--bit testing
if i.bit_and (1) = 0 then
	-- i is even
end

--built-in bit testing (uses bit_and)
if i.bit_test (0) then
	-- i is odd
end

--integer remainder (modulo)
if i \\ 2 = 0 then
	-- i is even
end
