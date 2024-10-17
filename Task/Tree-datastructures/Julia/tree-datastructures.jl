const nesttext = """
RosettaCode
    rocks
        code
        comparison
        wiki
    mocks
        trolling
"""

function nesttoindent(txt)
    ret = ""
    windent = gcd(length.([x.match for x in eachmatch(r"\s+", txt)]) .- 1)
    for lin in split(txt, "\n")
        ret *= isempty(lin) ? "\n" : isspace(lin[1]) ?
            replace(lin, r"\s+" => (s) -> "$(length(s)÷windent)    ") * "\n" :
            "0    " * lin * "\n"
    end
    return ret, " "^windent
end

function indenttonest(txt, indenttext)
    ret = ""
    for lin in filter(x -> length(x) > 1, split(txt, "\n"))
        (num, name) = split(lin, r"\s+", limit=2)
        indentnum = parse(Int, num)
        ret *= indentnum == 0 ? name * "\n" : indenttext^indentnum * name * "\n"
    end
    return ret
end

indenttext, itext = nesttoindent(nesttext)
restorednesttext = indenttonest(indenttext, itext)

println("Original:\n", nesttext, "\n")
println("Indent form:\n", indenttext, "\n")
println("Back to nest form:\n", restorednesttext, "\n")
println("original == restored: ", strip(nesttext) == strip(restorednesttext))
