using Printf

function stringpoly(n::Int64)
    if n < 0
        return ""
    end
    st = @sprintf "(x - 1)^{%d} & = & " n
    for (i, c) in enumerate(polycoefs(n))
        if i == 1
            op = ""
            ac = c
        elseif c < 0
            op = "-"
            ac = abs(c)
        else
            op = "+"
            ac = abs(c)
        end
        p = n + 1 - i
        if p == 0
            st *= @sprintf " %s %d\\\\" op ac
        elseif ac == 1
            st *= @sprintf " %s x^{%d}" op p
        else
            st *= @sprintf " %s %dx^{%d}" op ac p
        end
    end
    return st
end
