-- Define the constants
local p = 1.32471795724474602596
local s = 1.0453567932525329623


-- Generator for the Padovan sequence using coroutines
function pad_recur_gen(n)
    local co = coroutine.create(function ()
        local p = {1, 1, 1, 2}
        for i = 1, n do
            local next_val = p[2] + p[3]
            coroutine.yield(p[1])
            table.remove(p, 1)
            table.insert(p, next_val)
        end
    end)
    return function ()   -- iterator
        local status, value = coroutine.resume(co)
        return value
    end
end

-- Padovan floor function
function pad_floor(index)
    if index < 3 then
        return math.floor(1/2 + p)
    else
        return math.floor(1/2 + p^(index - 2) / s)
    end
end

local l, m, n = 10, 20, 32

local pr = {}
local pad_recur = pad_recur_gen(n)
for i = 1, n do
    pr[i] = pad_recur()
end
for i = 1, m do
    io.write(pr[i] .. ' ')
end
io.write('\n')

local pf = {}
for i = 1, n do
    pf[i] = pad_floor(i)
end
for i = 1, m do
    io.write(pf[i] .. ' ')
end
io.write('\n')

local L = {'A'}
local rules = { A = 'B', B = 'C', C = 'AB' }
for i = 1, n do
    local next_str = ''
    for char in L[#L]:gmatch('.') do
        next_str = next_str .. rules[char]
    end
    table.insert(L, next_str)
end
for i = 1, l do
    io.write(L[i] .. ' ')
end
io.write('\n')

for i = 1, n do
    assert(pr[i] == pf[i] and pr[i] == #L[i],
           "Uh oh, n=" .. i .. ": " .. pr[i] .. " vs " .. pf[i] .. " vs " .. #L[i])
end

print('100% agreement among all 3 methods.')
