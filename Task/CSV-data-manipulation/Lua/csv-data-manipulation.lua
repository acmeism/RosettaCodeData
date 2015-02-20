local csv={}
for line in io.lines('file.csv') do
    table.insert(csv, {})
    local i=1
    for j=1,#line do
        if line:sub(j,j) == ',' then
            table.insert(csv[#csv], line:sub(i,j-1))
            i=j+1
        end
    end
    table.insert(csv[#csv], line:sub(i,j))
end

table.insert(csv[1], 'SUM')
for i=2,#csv do
    local sum=0
    for j=1,#csv[i] do
        sum=sum + tonumber(csv[i][j])
    end
    if sum>0 then
        table.insert(csv[i], sum)
    end
end

local newFileData = ''
for i=1,#csv do
    newFileData=newFileData .. table.concat(csv[i], ',') .. '\n'
end

local file=io.open('file.csv', 'w')
file:write(newFileData)
