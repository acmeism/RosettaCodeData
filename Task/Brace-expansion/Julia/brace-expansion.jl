 function getitem(s, depth=0)
    out = [""]
    while s != ""
        c = s[1]
        if depth > 0 && (c == ',' || c == '}')
            return out, s
        elseif c == '{'
            x = getgroup(s[2:end], depth+1)
            if x != ""
                out, s = [a * b for a in out, b in x[1]], x[2]
                continue
            end
        elseif c == '\\' && length(s) > 1
            s, c = s[2:end], c * s[2]
        end
        out, s = [a * c for a in out], s[2:end]
    end
    return out, s
end

function getgroup(s, depth)
    out, comma = "", false
    while s != ""
        g, s = getitem(s, depth)
        if s == ""
            break
        end
        out = vcat([out...], [g...])
        if s[1] == '}'
            if comma
                return out, s[2:end]
            end
            return ["{" * a * "}" for a in out], s[2:end]
        end
        if s[1] == ','
            comma, s = true, s[2:end]
        end
    end
    return ""
end

const teststrings = [raw"~/{Downloads,Pictures}/*.{jpg,gif,png}",
                    raw"It{{em,alic}iz,erat}e{d,}, please.",
                    raw"{,{,gotta have{ ,\, again\, }}more }cowbell!",
                    raw"{}} some }{,{\\\\{ edge, edge} \,}{ cases, {here} \\\\\\\\\}'''"]

for s in teststrings
    println("\n", s, "\n--------------------------------------------")
    for ans in getitem(s)[1]
        println(ans)
    end
end
