function table.reverse(a)
    local res = {}
    for i = #a, 1, -1 do
        res[#res+1] = a[i]
    end
    return res
end

function splittokens(s)
    local res = {}
    for w in s:gmatch("%S+") do
        res[#res+1] = w
    end
    return res
end

for line, nl in s:gmatch("([^\n]-)(\n)") do
    print(table.concat(table.reverse(splittokens(line)), ' '))
end
