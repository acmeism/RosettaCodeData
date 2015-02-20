squares = {}

for i = 0, 9 do
    for j = 0, 9 do
        squares[i * 10 + j] = i * i + j * j
    end
end

for i = 1, 99 do
    for j = 0, 99 do
        squares[i * 100 + j] = squares[i] + squares[j]
    end
end

function sum_squares(n)
    if n < 9999.5 then
        return squares[n]
    else
        local m = math.floor(n / 10000)
        return squares[n - 10000 * m] + sum_squares(m)
    end
end

memory = {}

function calc_1_or_89(n)
    local m = {}
    n = memory[n] or n
    while n ~= 1 and n ~= 89 do
        n = memory[n] or sum_squares(n)
        table.insert(m, n)
    end
    for _, i in pairs(m) do
        memory[i] = n
    end
    return n
end

counter = 0

for i = 1, 100000000 do
    if calc_1_or_89(i) == 89 then
        counter = counter + 1
    end
end

print(counter)
