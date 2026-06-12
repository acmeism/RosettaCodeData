def f(n)
    if n < 1 then
        return
    end

    i = 1
    while true do
        sq = i * i
        while sq > n do
            sq = (sq / 10).floor
        end
        if sq == n then
            print "%3d %9d %4d\n" % [n, i * i, i]
            return
        end
        i = i + 1
    end
end

print("Prefix    n^2    n\n")
print()
for i in 1 .. 49
    f(i)
end
