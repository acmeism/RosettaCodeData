-- Task 1
function harmonic (n)
    if n < 1 or n ~= math.floor(n) then
        error("Argument to harmonic function is not a natural number")
    end
    local Hn = 1
    for i = 2, n do
        Hn = Hn + (1/i)
    end
    return Hn
end

-- Task 2
for x = 1, 20 do
    print(x .. " :\t" .. harmonic(x))
end

-- Task 3
local x, lastInt, Hx = 0, 1
repeat
    x = x + 1
    Hx = harmonic(x)
    if Hx > lastInt then
        io.write("The first harmonic number above " .. lastInt)
        print(" is " .. Hx .. " at position " .. x)
        lastInt = lastInt + 1
    end
until lastInt > 10  -- Stretch goal just meant changing that value from 5 to 10
                    -- Execution still only takes about 120 ms under LuaJIT
