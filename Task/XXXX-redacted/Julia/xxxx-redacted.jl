function doif_equals(word, pattern, insens=false)
    regex = insens ? Regex("^$pattern\$", "i") : Regex("^$pattern\$")
    return replace(word, regex => pattern in multichars ? "X" : "X"^length(pattern))
end
doif_ci_equals(word, pattern) = doif_equals(word, pattern, true)

function doif_includes(word, pattern, insens=false)
    regex = insens ? Regex(pattern, "i") : Regex(pattern)
    return replace(word, regex => "X"^length(pattern))
end
doif_ci_includes(word, pattern) = doif_includes(word, pattern, true)

function overkill(word, pattern, insens=false)
    regex = insens ? Regex(pattern, "i") : Regex(pattern)
    return occursin(regex, word) ? "X"^length(word) : word
end
ci_overkill(word, pattern) = overkill(word, pattern, true)

const method = Dict(
    "[w|s|n]" => doif_equals,
    "[w|i|n]" => doif_ci_equals,
    "[p|s|n]" => doif_includes,
    "[p|i|n]" => doif_ci_includes,
    "[p|s|o]" => overkill,
    "[p|i|o]" => ci_overkill
)
const multichars = Set(["👨‍👩‍👦", ])

function redact(teststring, pattern)
    ws = split(teststring, r"[^ \?\"\.]+")
    words = filter(!=(""), split(teststring, r"[\s\?\"\.]+"))
    fs = popfirst!(words)
    f = method[fs]
    return fs * ws[2] * mapreduce(i -> f(words[i], pattern) * ws[i + 2], *, 1:length(words))
end

const testtext = """
[w|s|n] Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
[w|i|n] Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
[p|s|n] Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
[p|i|n] Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
[p|s|o] Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
[p|i|o] Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
"""
const stretchtext = "[w|s|n] 🧑 👨 🧔 👨‍👩‍👦"

for test in [(testtext, ["Tom", "tom"]), (stretchtext, ["👨", "👨‍👩‍👦"])]
    for pat in test[2]
        println("\nRedact pattern \"$pat\":")
        for teststring in string.(split(strip(test[1]), r"\n"))
            println(redact(teststring, pat))
        end
    end
    println()
end
