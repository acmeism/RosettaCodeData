const irregular = Dict("one" => "first", "two" => "second", "three" => "third", "five" => "fifth",
                                "eight" => "eighth", "nine" => "ninth", "twelve" => "twelfth")
const suffix = "th"
const ysuffix = "ieth"

function numtext2ordinal(s)
    lastword = split(s)[end]
    redolast = split(lastword, "-")[end]
    if redolast != lastword
        lastsplit = "-"
        word = redolast
    else
        lastsplit = " "
        word = lastword
    end
    firstpart = reverse(split(reverse(s), lastsplit, limit=2)[end])
    firstpart = (firstpart == word) ? "": firstpart * lastsplit
    if haskey(irregular, word)
        word = irregular[word]
    elseif word[end] == 'y'
        word = word[1:end-1] * ysuffix
    else
        word = word * suffix
    end
    firstpart * word
end

const testcases =  [1  2  3  4  5  11  65  100  101  272  23456  8007006005004003]
for n in testcases
    println("$n => $(numtext2ordinal(num2text(n)))")
end
