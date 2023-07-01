-- Variadic, first argument is the value with which to populate the array.
function multiArray (initVal, ...)
    local function copy (t)
        local new = {}
        for k, v in pairs(t) do
            if type(v) == "table" then
                new[k] = copy(v)
            else
                new[k] = v
            end
        end
        return new
    end
    local dimensions, arr, newArr = {...}, {}
    for i = 1, dimensions[#dimensions] do table.insert(arr, initVal) end
    for d = #dimensions - 1, 1, -1 do
        newArr = {}
        for i = 1, dimensions[d] do table.insert(newArr, copy(arr)) end
        arr = copy(newArr)
    end
    return arr
end

-- Function to print out the specific example created here
function show4dArray (a)
    print("\nPrinting 4D array in 2D...")
    for k, v in ipairs(a) do
        print(k)
        for l, w in ipairs(v) do
            print("\t" .. l)
                for m, x in ipairs(w) do
                    print("\t", m, unpack(x))
                end
        end
    end
end

-- Main procedure
local t = multiArray("a", 2, 3, 4, 5)
show4dArray(t)
t[1][1][1][1] = true
show4dArray(t)
