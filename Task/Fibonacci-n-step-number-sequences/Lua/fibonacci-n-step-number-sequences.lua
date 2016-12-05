function n_Nacci (n, seqLength, lucas)
    local seq, nextNum = {1}
    if lucas then
        seq = {2, 1}
    else
        for power = 1, n - 1 do
            table.insert(seq, 2 ^ power)
        end
    end
    while #seq < seqLength do
        nextNum = 0
        for i = #seq - (n-1), #seq do
            nextNum = nextNum + seq[i]
        end
        table.insert(seq, nextNum)
    end
    return seq
end

function display (t)
    print(" n\t|\t\t\tValues")
    print(string.rep("-", 75))
    for k, v in pairs(t) do
        io.write(" " .. k, "\t| ")
        for _, val in pairs(v) do
            io.write(val .. " ")
        end
        print("...")
    end
end

local nacciTab = {}
for n = 2, 10 do
    nacciTab[n] = n_Nacci(n, 16) -- 16 of each fits in one cmd line
end
nacciTab.lucas = n_Nacci(2, 16, "lucas")
display(nacciTab)
