d = [false] * 101
open = []
for p in range(1, 100)
    for t in range(p, 100, p)
        d[t] = not d[t]
    end for
    if d[p] then open.push p
end for

print open
