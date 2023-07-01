const teststringpairs = [
    ("", ' '),
    (""""If I were two-faced, would I be wearing this one?" --- Abraham Lincoln """, '-'),
    ("..1111111111111111111111111111111111111111111111111111111111111117777888", '7'),
    ("""I never give 'em hell, I just tell the truth, and they think it's hell. """, '.'),
    ("                                                    --- Harry S Truman  ", ' '),
    ("                                                    --- Harry S Truman  ", '-'),
    ("                                                    --- Harry S Truman  ", 'r')]

function squeezed(s, c)
    t = isempty(s) ? "" : s[1:1]
    for x in s[2:end]
        if x != t[end] || x != c
            t *= x
        end
    end
    t
end

for (s, c) in teststringpairs
    n, t = length(s), squeezed(s, c)
    println("«««$s»»» (length $n)\n",
        s == t ? "is not squeezed, so remains" : "squeezes to",
        ":\n«««$t»»» (length $(length(t))).\n")
end
