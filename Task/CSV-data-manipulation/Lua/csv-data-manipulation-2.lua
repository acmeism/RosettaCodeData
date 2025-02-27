local csv={}

-- read csv file, save records and fields into table
for line in io.lines('file.csv') do
    local fields = {}
    for field in line:gmatch"[^,]+" do
        table.insert(fields, tonumber(field) or field)
    end
    table.insert(csv, fields)
end

-- change csv values
table.insert(csv[1], 'SUM')
for i=2,#csv do
    local sum=0
    for _, val in ipairs(csv[i]) do
        sum = sum + val
    end
    table.insert(csv[i], sum)
end

-- Save
local fileHandler = io.open('file.csv', 'w')
for NR, fields in ipairs(csv) do
    fileHandler:write(table.concat(fields,","), "\n")
end
