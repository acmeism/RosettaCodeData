function identical(t_str)
    _, fst = next(t_str)
    if fst then
        for _, i in pairs(t_str) do
            if i ~= fst then return false end
        end
    end
    return true
end

function ascending(t_str)
    prev = false
    for _, i in ipairs(t_str) do
        if prev and prev >= i then return false end
        prev = i
    end
    return true
end

function check(str)
    t_str = {}
    for i in string.gmatch(str, "[%a_]+") do
        table.insert(t_str, i)
    end
    str = str .. ": "
    if not identical(t_str) then str = str .. "not " end
    str = str .. "identical and "
    if not ascending(t_str) then str = str .. "not " end
    print(str .. "ascending.")
end

check("ayu dab dog gar panda tui yak")
check("oy oy oy oy oy oy oy oy oy oy")
check("somehow   somewhere  sometime")
check("Hoosiers")
check("AA,BB,CC")
check("AA,AA,AA")
check("AA,CC,BB")
check("AA,ACB,BB,CC")
check("single_element")
