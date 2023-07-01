function randomarray()
    local t = {}
    for i = 1, math.random(1, 10) do
        t[i] = math.random(1, 10)
    end
    return t
end

math.randomseed(os.time())

for i = 1, 10 do
    local a = randomarray()
    local b = randomarray()

    print(
        string.format("{%s} %s {%s}",
        table.concat(a, ', '),
        arraycompare(a, b) and "<=" or ">",
        table.concat(b, ', ')))
end
