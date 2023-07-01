local a = {[0]=0}
local used = {[0]=true}
local used1000 = {[0]=true}
local foundDup = false
local n = 1

while n<=15 or not foundDup or #used1000<1001 do
    local nxt = a[n - 1] - n
    if nxt<1 or used[nxt] ~= nil then
        nxt = nxt + 2 * n
    end
    local alreadyUsed = used[nxt] ~= nil
    table.insert(a, nxt)
    if not alreadyUsed then
        used[nxt] = true
        if 0<=nxt and nxt<=1000 then
            used1000[nxt] = true
        end
    end
    if n==14 then
        io.write("The first 15 terms of the Recaman sequence are:")
        for k=0,#a do
            io.write(" "..a[k])
        end
        print()
    end
    if not foundDup and alreadyUsed then
        print("The first duplicated term is a["..n.."] = "..nxt)
        foundDup = true
    end
    if #used1000 == 1001 then
        print("Terms up to a["..n.."] are needed to generate 0 to 1000")
    end
    n = n + 1
end
