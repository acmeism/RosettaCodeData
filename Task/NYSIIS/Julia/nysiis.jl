using Printf

function replaceat(text::AbstractString, position::Int, fromlist, tolist)
    for (f, t) in zip(fromlist, tolist)
        if startswith(text[position:end], f)
            return text[1:position-1] * t * text[position+length(f):end]
        end
    end
    return text
end

function replaceend(text::AbstractString, fromlist, tolist)
    for (f, t) in zip(fromlist, tolist)
        if endswith(text, f)
            return text[1:end-length(f)] * t
        end
    end
    return text
end

function nysiis(name::AbstractString)
    vowels = ["A", "E", "I", "O", "U"]

    name = uppercase(filter(isalpha, name))
    name = replaceat(name, 1, ["MAC", "KN", "K", "PH", "PF", "SCH"],
                               ["MCC", "N",  "C", "FF", "FF", "SSS"])
    name = replaceend(name, ["EE", "IE", "DT", "RT", "RD", "NT", "ND"],
                             ["Y",  "Y",  "D",  "D",  "D",  "D",  "D"])
    key, key1 = name[1:1], ""
    for i in 2:length(name)
        prev, curr = name[(i:i).-1], name[i:i]
        next = i < length(name) ? name[(i:i).+1] : ""
        name = replaceat(name, i, vcat("EV", vowels), ["AF", "A", "A", "A", "A", "A"])
        name = replaceat(name, i, "QZM", "GSN")
        name = replaceat(name, i, ["KN", "K"], ["N", "C"])
        name = replaceat(name, i, ["SCH", "PH"], ["SSS", "FF"])
        if curr == "H" && (prev ∉ vowels || next ∉ vowels)
            name = name[1:i-1] * prev * name[i+1:end]
        end
        if curr == "W" && prev ∈ vowels
            name = name[1:i-1] * "A" * name[i+1:end]
        end
        if !isempty(key) && key[end:end] != name[i:i]
            key *= name[i:i]
        end
        i += 1
    end
    key = replaceend(key, ["S"],  [""])
    key = replaceend(key, ["AY"], ["Y"])
    key = replaceend(key, ["A"],  [""])
    return key1 * key
end

for name in ["Bishop", "Carlson", "Carr", "Chapman", "Franklin",
             "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
             "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews",
             "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
             "O'Banion", "O'Brien", "Richards", "Silva", "Watkins",
             "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
             "knight", "mitchell", "o'daniel"]
    @printf("%15s: %s\n", name, nysiis(name))
end
