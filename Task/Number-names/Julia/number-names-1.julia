const stext = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
const teentext = ["eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",
    "seventeen", "eighteen", "nineteen"]
const tenstext = ["ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy",
    "eighty", "ninety"]
const ordstext = ["million", "billion", "trillion", "quadrillion", "quintillion", "sextillion",
    "septillion", "octillion", "nonillion", "decillion", "undecillion", "duodecillion",
    "tredecillion", "quattuordecillion", "quindecillion", "sexdecillion", "septendecillion",
    "octodecillion", "novemdecillion", "vigintillion"]

function normalize_digits!(a::Array{T,1}) where T<:Integer
    while 0 < length(a) && a[end] == 0
        pop!(a)
    end
    length(a)
end

function digits2text!(d::Array{T,1}, use_short_scale=true) where T<:Integer
    ndig = normalize_digits!(d)
    0 < ndig || return ""
    if ndig < 7
        s = ""
        if 3 < ndig
            t = digits2text!(d[1:3])
            s = digits2text!(d[4:end]) * " thousand"
            0 < length(t) || return s
            return occursin(t, "and") ? s * " " * t : s * " and " * t
        end
        if ndig == 3
            s *= stext[pop!(d)] * " hundred"
            ndig = normalize_digits!(d)
            0 < ndig || return s
            s *= " and "
        end
        1 < ndig || return s*stext[pop!(d)]
        j, i = d
        j ≠ 0 || return s*tenstext[i]
        i ≠ 1 || return s*teentext[j]
        return s*tenstext[i] * "-" * stext[j]
    end
    s = digits2text!(d[1:6])
    d = d[7:end]
    dgrp = use_short_scale ? 3 : 6
    ord = 0
    while dgrp < length(d)
        ord += 1
        t = digits2text!(d[1:dgrp])
        d = d[(dgrp+1):end]
        0 < length(t) || continue
        t = t * " " * ordstext[ord]
        s = length(s) == 0 ? t : t * " " * s
    end
    ord += 1
    t = digits2text!(d) * " " * ordstext[ord]
    0 < length(s) || return t
    t * " " * s
end

function num2text(n::T, use_short_scale=true) where T<:Integer
    -1 < n || return "minus "*num2text(-n, use_short_scale)
    0 < n || return "zero"
    toobig = use_short_scale ? big(10)^66 : big(10)^126
    n < toobig || return "too big to say"
    digits2text!(digits(n, base=10), use_short_scale)
end
