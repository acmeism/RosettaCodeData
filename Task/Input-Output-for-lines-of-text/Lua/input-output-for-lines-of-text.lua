function show (t)
    for _, line in pairs(t) do print(line) end
end

local lineTable, numLines = {}, io.read()
for i = 1, numLines do table.insert(lineTable, io.read()) end
show(lineTable)
