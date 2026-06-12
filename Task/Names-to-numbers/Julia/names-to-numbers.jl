const stext = ["one", "two", "three", "four", "five",
               "six", "seven", "eight", "nine"]
const teentext = ["eleven", "twelve", "thirteen", "fourteen",
                  "fifteen", "sixteen", "seventeen",
                  "eighteen", "nineteen"]
const tenstext = ["ten", "twenty", "thirty", "forty", "fifty",
                  "sixty", "seventy", "eighty", "ninety"]
const ordstext = ["million", "billion", "trillion",
                  "quadrillion", "quintillion", "sextillion",
                  "septillion", "octillion", "nonillion",
                  "decillion", "undecillion", "duodecillion",
                  "tredecillion", "quattuordecillion", "quindecillion",
                  "sexdecillion", "septendecillion", "octodecillion",
                  "novemdecillion", "vigintillion"]

allnumeric = vcat(
    stext, teentext, tenstext, ordstext, ["minus", "and", "hundred", "thousand", "zero"]
)
canon(word) = replace(lowercase(word), r"\-|\,|\.|\:" => "")
isnumeric(word) = canon(word) in allnumeric

function parsenumericphrases(txt)
    words = split(strip(txt), r"(\s+)|(\s*\-\s*)")
    phrases, num, alph = Vector{Pair{Bool, Vector{String}}}(), false, false
    for (i, word) in enumerate(words)
        if isnumeric(word) && (num || word != "and")
            if !num
                push!(phrases, Pair(true, String[]))
                num, alph = true, false
            end
            if word != "and"
                push!(phrases[end][2], canon(word))
            end
        else
            if !alph
                push!(phrases, Pair(false, String[]))
                num, alph = false, true
                if length(phrases) > 1 && !occursin(r"\w", words[i - 1][end:end])
                    word = words[i - 1][end] * " " * word
                end
            end
            push!(phrases[end][2], word)
        end
    end
    return phrases
end

function sumones(word, total)
    n = something(findfirst(x -> x == word, stext), 0)
    x = something(findfirst(x -> x == word, teentext), 0)
    (x > 0) && (n += (10 + x))
    n += something(findfirst(x -> x == word, tenstext), 0) * 10
    return n + total
end

sumhundreds(word, total) = word == "hundred" ? total *= 100 : total

function summils(word, miltotal, onestotal)
    if word == "thousand"
        return miltotal + onestotal * 1000, 0
    elseif (x = something(findfirst(x -> x == word, ordstext), 0)) > 0
        return miltotal + onestotal * 1000^(x + 1), 0
    else
        return miltotal, onestotal
    end
end

function texttointeger(txt)
    phrasepairs, outputphrases = parsenumericphrases(txt), String[]
    for phrase in phrasepairs
        if phrase[1]  # numeric phrase
            wordarray, sign, onestotal, miltotal = phrase[2], 1, 0, 0
            for word in wordarray
                onestotal = sumones(word, onestotal)
                onestotal = sumhundreds(word, onestotal)
                miltotal, onestotal = summils(word, miltotal, onestotal)
            end
            push!(outputphrases, string(sign * (onestotal + miltotal)))
        else # non-numeric phrase
            push!(outputphrases, join(phrase[2], " "))
        end
    end
    return replace(join(outputphrases, " "), r"([\w\d])\s(\,|\:|\;|\.)" => s"\1\2")
end

const examples = """
One Hundred and One Dalmatians
Two Thousand and One: A Space Odyssey
Four  Score  And  Seven  Years  Ago
twelve dozen is one hundred forty-four, aka one gross
two hundred pairs of socks
Always give one hundred and ten percent effort
Change due: zero dollars and thirty-seven cents
One hour, fifty-nine minutes, forty point two seconds
Two Thousand Nineteen
Two Thousand Zero Hundred and Nineteen
Two Thousand Ten Nine
one thousand one
ninety nine thousand nine hundred ninety nine
five hundred and twelve thousand, six hundred and nine
two billion, one hundred
One Thousand One Hundred Eleven
Eleven Hundred Eleven
one hundred eleven billion one hundred eleven
Eight Thousand Eight Hundred Eighty-Eight
Eighty-Eight Hundred Eighty-Eight
one quadrillion, two trillion, three billion, four million, five thousand six
"""

for txt in split(strip(examples), r"\n")
    println(txt, " => ", texttointeger(txt))
end
