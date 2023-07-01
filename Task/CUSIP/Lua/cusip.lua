function checkDigit (cusip)
  if #cusip ~= 8 then return false end

  local sum, c, v, p = 0
  for i = 1, 8 do
    c = cusip:sub(i, i)
    if c:match("%d") then
      v = tonumber(c)
    elseif c:match("%a") then
      p = string.byte(c) - 55
      v = p + 9
    elseif c == "*" then
      v = 36
    elseif c == "@" then
      v = 37
    elseif c == "#" then
      v = 38
    end
    if i % 2 == 0 then
      v = v * 2
    end

    sum = sum + math.floor(v / 10) + v % 10
  end

  return tostring((10 - (sum % 10)) % 10)
end

local testCases = {
  "037833100",
  "17275R102",
  "38259P508",
  "594918104",
  "68389X106",
  "68389X105"
}
for _, CUSIP in pairs(testCases) do
  io.write(CUSIP .. ": ")
  if checkDigit(CUSIP:sub(1, 8)) == CUSIP:sub(9, 9) then
    print("VALID")
  else
    print("INVALID")
  end
end
