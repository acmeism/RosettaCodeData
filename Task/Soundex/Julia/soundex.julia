using Soundex
@assert soundex("Ashcroft") == "A261"  # true

# Too trivial? OK. Here is an example not using a package:
function soundex(s)
    char2num = Dict('B'=>1,'F'=>1,'P'=>1,'V'=>1,'C'=>2,'G'=>2,'J'=>2,'K'=>2,
        'Q'=>2,'S'=>2,'X'=>2,'Z'=>2,'D'=>3,'T'=>3,'L'=>4,'M'=>5,'N'=>5,'R'=>6)
    s = replace(s, r"[^a-zA-Z]", "")
    if s == ""
        return ""
    end
    ret = "$(uppercase(s[1]))"
    hadvowel = false
    lastletternum = haskey(char2num, ret[1]) ? char2num[ret[1]] : ""
    for c in s[2:end]
        c = uppercase(c)
        if haskey(char2num, c)
            letternum = char2num[c]
            if letternum != lastletternum || hadvowel
                ret = "$ret$letternum"
                lastletternum = letternum
                hadvowel = false
            end
        elseif c in ('A', 'E', 'I', 'O', 'U', 'Y')
            hadvowel = true
        end
    end
    while length(ret) < 4
        ret *= "0"
    end
    ret[1:4]
end
@assert soundex("Ascroft")     == "A261"
@assert soundex("Euler")       == "E460"
@assert soundex("Gausss")      == "G200"
@assert soundex("Hilbert")     == "H416"
@assert soundex("Knuth")       == "K530"
@assert soundex("Lloyd")       == "L300"
@assert soundex("Lukasiewicz") == "L222"
@assert soundex("Ellery")      == "E460"
@assert soundex("Ghosh")       == "G200"
@assert soundex("Heilbronn")   == "H416"
@assert soundex("Kant")        == "K530"
@assert soundex("Ladd")        == "L300"
@assert soundex("Lissajous")   == "L222"
@assert soundex("Wheaton")     == "W350"
@assert soundex("Ashcraft")    == "A261"
@assert soundex("Burroughs")   == "B620"
@assert soundex("Burrows")     == "B620"
@assert soundex("O'Hara")      == "O600"
