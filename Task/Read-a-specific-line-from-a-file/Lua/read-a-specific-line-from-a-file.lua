function fileLine (lineNum, fileName)
  local count = 0
  for line in io.lines(fileName) do
    count = count + 1
    if count == lineNum then return line end
  end
  error(fileName .. " has fewer than " .. lineNum .. " lines.")
end

print(fileLine(7, "test.txt"))
