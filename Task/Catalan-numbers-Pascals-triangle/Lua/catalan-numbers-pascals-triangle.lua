function nextrow (t)
    local ret = {}
    t[0], t[#t + 1] = 0, 0
    for i = 1, #t do ret[i] = t[i - 1] + t[i] end
    return ret
end

function catalans (n)
    local t, middle = {1}
    for i = 1, n do
        middle = math.ceil(#t / 2)
        io.write(t[middle] - (t[middle + 1] or 0) .. " ")
        t = nextrow(nextrow(t))
    end
end

catalans(15)
