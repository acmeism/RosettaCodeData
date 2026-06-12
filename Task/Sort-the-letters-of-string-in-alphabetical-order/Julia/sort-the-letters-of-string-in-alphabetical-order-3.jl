const alphabets = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"

function lettercountingsort(s)
    sorted = Char[]
    for l in alphabets
       append!(sorted, fill(l, count(==(l), s)))
    end
    return String(sorted)
end

println(lettercountingsort("Now is the time for all good men to come to the aid of their country."))
