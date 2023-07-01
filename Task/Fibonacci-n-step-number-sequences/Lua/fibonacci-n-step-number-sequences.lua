function nStepFibs (seq, limit)
    local iMax, sum = #seq - 1
    while #seq < limit do
        sum = 0
        for i = 0, iMax do sum = sum + seq[#seq - i] end
        table.insert(seq, sum)
    end
    return seq
end

local fibSeqs = {
    {name = "Fibonacci",  values = {1, 1}      },
    {name = "Tribonacci", values = {1, 1, 2}   },
    {name = "Tetranacci", values = {1, 1, 2, 4}},
    {name = "Lucas",      values = {2, 1}      }
}
for _, sequence in pairs(fibSeqs) do
    io.write(sequence.name .. ": ")
    print(table.concat(nStepFibs(sequence.values, 10), " "))
end
