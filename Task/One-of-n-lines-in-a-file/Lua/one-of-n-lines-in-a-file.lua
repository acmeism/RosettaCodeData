math.randomseed(os.time())

local n = 10
local trials = 1000000

function one(n)
    local chosen = 1
    for i = 1, n do
        if math.random() < 1/i then
            chosen = i
        end
    end

    return chosen
end

-- 0 filled table for storing results
local results = {}
for i = 1, n do results[i] = 0 end

-- run simulation
for i = 1, trials do
    local result = one(n)
    results[result] = results[result] + 1
end

print("Value","Occurrences")
print("-------------------")
for k, v in ipairs(results) do
    print(k,v)
end
