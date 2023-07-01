lines = {}
str = io.read()
while str do
    table.insert(lines,str)
    str = io.read()
end
