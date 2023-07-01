local primes = {3, 5}
local cutOff = 200
local bigUn = 100000
local chunks = 50
local little = math.floor(bigUn / chunks)
local tn = " cuban prime"
print(string.format("The first %d%ss", cutOff, tn))
local showEach = true
local c = 0
local u = 0
local v = 1
for i=1,10000000000000 do
    local found = false
    u = u + 6
    v = v + u
    local mx = math.ceil(math.sqrt(v))
    --for _,item in pairs(primes) do -- why: latent traversal bugfix (and performance), 6/11/2020 db
    for _,item in ipairs(primes) do
        if item > mx then
            break
        end
        if v % item == 0 then
            --print("[DEBUG] :( i = " .. i .. "; v = " .. v)
            found = true
            break
        end
    end
    if not found then
        --print("[DEBUG] :) i = " .. i .. "; v = " .. v)
        c = c + 1
        if showEach then
            --local z = primes[table.getn(primes)] + 2 -- why: modernize (deprecated), 6/11/2020 db
            local z = primes[#primes] + 2
            while z <= v - 2 do
                local fnd = false
                --for _,item in pairs(primes) do -- why: latent traversal bugfix (and performance), 6/11/2020 db
                for _,item in ipairs(primes) do
                    if item > mx then
                        break
                    end
                    if z % item == 0 then
                        fnd = true
                        break
                    end
                end
                if not fnd then
                    table.insert(primes, z)
                end
                z = z + 2
            end
            table.insert(primes, v)
            io.write(string.format("%11d", v))
            if c % 10 == 0 then
                print()
            end
            if c == cutOff then
                showEach = false
                io.write(string.format("\nProgress to the %dth%s: ", bigUn, tn))
            end
        end
        if c % little == 0 then
            io.write(".")
            if c == bigUn then
                break
            end
        end
    end
end
--print(string.format("\nThe %dth%s is %17d", c, tn, v)) -- why: correcting reported inaccuracy in output, 6/11/2020 db
print(string.format("\nThe %dth%s is %.0f", c, tn, v))
