-- Lua bindings for GNU bc
require("bc")

-- Return table of factorials from 0 to n
function facsUpTo (n)
    local f, fList = bc.number(1), {}
    fList[0] = 1
    for i = 1, n do
        f = bc.mul(f, i)
        fList[i] = f
    end
    return fList
end

-- Return left factorial of n
function leftFac (n)
    local sum = bc.number(0)
    for k = 0, n - 1 do sum = bc.add(sum, facList[k]) end
    return bc.tostring(sum)
end

-- Main procedure
facList = facsUpTo(10000)
for i = 0, 10 do print("!" .. i .. " = " .. leftFac(i)) end
for i = 20, 110, 10 do print("!" .. i .. " = " .. leftFac(i)) end
for i = 1000, 10000, 1000 do
    print("!" .. i .. " contains " .. #leftFac(i) .. " digits")
end
