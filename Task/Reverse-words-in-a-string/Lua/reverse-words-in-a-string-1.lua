function splittokens(s)
    local res = {}
    for w in s:gmatch("%S+") do
        res[#res+1] = w
    end
    return res
end

function reverse(a,b) return a>b end

for line in io.lines"input.txt" do
    print(table.concat(table.sort(splittokens(line), reverse), ' '))
end
