Lines = {}
for line in io.lines(arg[1], "l") do
    table.insert(Lines, 1, line)
end
for _, line in ipairs(Lines) do
    print(line)
end
