function brent (f, x0)
    local tortoise, hare, mu = x0, f(x0), 0
    local cycleTab, power, lam = {tortoise, hare}, 1, 1
    while tortoise ~= hare do
        if power == lam then
            tortoise = hare
            power = power * 2
            lam = 0
        end
        hare = f(hare)
        table.insert(cycleTab, hare)
        lam = lam + 1
    end
    tortoise, hare = x0, x0
    for i = 1, lam do hare = f(hare) end
    while tortoise ~= hare do
        tortoise = f(tortoise)
        hare = f(hare)
        mu = mu + 1
    end
    return lam, mu, cycleTab
end

local f = function (x) return (x * x + 1) % 255 end
local x0 = 3
local cycleLength, startIndex, sequence = brent(f, x0)
print("Sequence:", table.concat(sequence, " "))
print("Cycle length:", cycleLength)
print("Start Index:", startIndex)
