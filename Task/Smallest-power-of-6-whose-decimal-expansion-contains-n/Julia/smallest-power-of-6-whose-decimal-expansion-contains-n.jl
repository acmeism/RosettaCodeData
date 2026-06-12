using Formatting

digcontains(n, dig) = contains(String(Char.(digits(n))), String(Char.(dig)))

function findpow6containing(needle)
    dig = digits(needle)
    for i in 0:1000
        p = big"6"^i
        digcontains(p, dig) && return p
    end
    error("could not find a  power of 6 containing $dig")
end

for n in 0:21
    println(rpad(n, 5), format(findpow6containing(n), commas=true))
end
