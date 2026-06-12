-- Decorate, sort, undecorate function
function dsu (tab, keyFunc)
    keyFunc = keyFunc or function (a, b) return a[2] < b[2] end
    for key, value in pairs(tab) do
        tab[key] = {value, #value}
    end
    table.sort(tab, keyFunc)
    for key, value in pairs(tab) do
        tab[key] = value[1]
    end
    return tab
end

-- Use default sort order by not specifying a key function
local list = {"Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"}
print(unpack(dsu(list)))

-- Create a custom key function and pass it as an argument
function descendingOrder (a, b)
    return a[2] > b[2]
end
print(unpack(dsu(list, descendingOrder)))
