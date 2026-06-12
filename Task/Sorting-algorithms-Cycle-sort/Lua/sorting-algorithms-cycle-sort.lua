function printa(a)
    io.write("[")
    for i,v in ipairs(a) do
        if i > 1 then
            io.write(", ")
        end
        io.write(v)
    end
    io.write("]")
end

function cycle_sort(a)
    local writes = 0

    local cycle_start = 0
    while cycle_start < #a - 1 do
        local val = a[cycle_start + 1]

        -- count the number of values that are smaller than val since cycle_start
        local pos = cycle_start
        local i = cycle_start + 1
        while i < #a do
            if a[i + 1] < val then
                pos = pos + 1
            end
            i = i + 1
        end

        -- there aren't any
        if pos ~= cycle_start then
            -- skip duplicates
            while val == a[pos + 1] do
                pos = pos + 1
            end

            -- put val in final position
            a[pos + 1], val = val, a[pos + 1]
            writes = writes + 1

            -- repeat as long as we can find values to swap
            -- otherwise start new cycle
            while pos ~= cycle_start do
                pos = cycle_start
                local i = cycle_start + 1
                while i < #a do
                    if a[i + 1] < val then
                        pos = pos + 1
                    end
                    i = i + 1
                end

                while val == a[pos + 1] do
                    pos = pos + 1
                end

                a[pos + 1], val = val, a[pos + 1]
                writes = writes + 1
            end
        end
        cycle_start = cycle_start + 1
    end

    return writes
end

arr = {5, 0, 1, 2, 2, 3, 5, 1, 1, 0, 5, 6, 9, 8, 0, 1}

printa(arr)
print()

writes = cycle_sort(arr)
printa(arr)
print()
print("writes: " .. writes)
