function F (n, x, y)
    if n == 0 then
        return x + y
    elseif y == 0 then
        return x
    else
        return F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y)
    end
end

local testCases = {
    {0, 0, 0},
    {1, 1, 1},
    {1, 3, 3},
    {2, 1, 1},
    {2, 2, 1},
    {3, 1, 1}
}

for _, v in pairs(testCases) do
    io.write("F(" .. table.concat(v, ",") .. ") = ")
    print(F(unpack(v)))
end
