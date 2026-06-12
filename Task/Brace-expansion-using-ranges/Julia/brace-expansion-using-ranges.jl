padzeros(str) = (len = length(str)) > 1 && str[1] == '0' ? len : 0

function ranged(str)
    rang = filter(!isempty, split(str, r"\{|\}|\.\."))
    delta = length(rang) > 2 ? parse(Int, rang[3]) : 1
    if delta < 0
        rang[1], rang[2], delta = rang[2], rang[1], -delta
    end
    if '0' <= rang[1][1] <= '9' || rang[1][1] == '-'
        try x, y = parse(Int, rang[1]), parse(Int, rang[2]) catch; return [str] end
        pad = max(padzeros(rang[1]), padzeros(rang[2]))
        return [string(x, pad=pad) for x in range(x, step=(x < y) ? delta : -delta, stop=y)]
    else
        x, y, z = rang[1][end], rang[2][end], rang[1][1:end-1]
        return [z * string(x) for x in range(x, step=(x < y) ? delta : -delta, stop=y)]
    end
end

function splatrange(s)
    m = match(r"([^\{]*)(\{[^}]+\.\.[^\}]+\})(.*)", s)
    m == nothing && return [s]
    c = m.captures
    return vec([a * b for b in splatrange(c[3]), a in [c[1] * x for x in ranged(c[2])]])
end

for test in [
    "simpleNumberRising{1..3}.txt",
    "simpleAlphaDescending-{Z..X}.txt",
    "steppedDownAndPadded-{10..00..5}.txt",
    "minusSignFlipsSequence {030..20..-5}.txt",
    "combined-{Q..P}{2..1}.txt",
    "emoji{🌵..🌶}{🌽..🌾}etc",
    "li{teral",
    "rangeless{}empty",
    "rangeless{random}string",
    "mixedNumberAlpha{5..k}",
    "steppedAlphaRising{P..Z..2}.txt",
    "stops after endpoint-{02..10..3}.txt",
    ]
    println(test, "->\n", ["    " * x * "\n" for x in splatrange(test)]...)
end
