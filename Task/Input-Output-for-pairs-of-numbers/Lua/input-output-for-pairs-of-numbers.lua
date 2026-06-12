local intTab, numLines, sum = {}, io.read()
for i = 1, numLines do
    sum = 0
    for number in io.read():gmatch("%S+") do sum = sum + number end
    table.insert(intTab, sum)
end
for _, result in pairs(intTab) do print(result) end
