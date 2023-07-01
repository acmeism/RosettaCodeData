function printVerse(name)
    local sb = string.lower(name)
    sb = sb:gsub("^%l", string.upper)
    local x = sb
    local x0 = x:sub(1,1)

    local y
    if x0 == 'A' or x0 == 'E' or x0 == 'I' or x0 == 'O' or x0 == 'U' then
        y = string.lower(x)
    else
        y = x:sub(2)
    end

    local b = "b" .. y
    local f = "f" .. y
    local m = "m" .. y

    if x0 == 'B' then
        b = y
    elseif x0 == 'F' then
        f = y
    elseif x0 == 'M' then
        m = y
    end

    print(x .. ", " .. x .. ", bo-" .. b)
    print("Banana-fana fo-" .. f)
    print("Fee-fi-mo-" .. m)
    print(x .. "!")
    print()

    return nil
end

local nameList = { "Gary", "Earl", "Billy", "Felix", "Mary", "Steve" }
for _,name in pairs(nameList) do
    printVerse(name)
end
