macro sum(i, loname, hiname, term)
    return quote
        lo = $loname
        hi = $hiname
        tmp = 0.0
        for i in lo:hi
            tmp += $term
        end
        return tmp
    end
end

i = 0
@sum(i, 1, 100, 1.0 / i)
