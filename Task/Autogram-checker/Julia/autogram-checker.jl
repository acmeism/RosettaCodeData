""" Rosetta Code task rosettacode.org/mw/index.php?title=Autogram_checker """

using DataStructures

const textnumbers = Dict("single" => 1, "one" => 1, "two" => 2, "three" => 3, "four" => 4,
    "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "ten" => 10, "eleven" => 11,
    "twelve" => 12, "thirteen" => 13, "fourteen" => 14, "fifteen" => 15, "sixteen" => 16,
    "seventeen" => 17, "eighteen" => 18, "nineteen" => 19, "twenty" => 20, "thirty" => 30,
    "forty" => 40, "fifty" => 50, "sixty" => 60, "seventy" => 70, "eighty" => 80, "ninety" => 90)

"""
    function phrasetointeger(txt)

Convert text spelled-out numbers from 1 to 999
"""
function phrasetointeger(txt)
    words = split(txt, r"\W+")
    n = 0
    for w in words
      n += get(textnumbers, w, 0)
        w == "hundred" && (n *= 100)
    end
    return n
end

"""
    function isautogram(txt, countpunctuation; verbose = true)

Verify an autogram. Count punctuation if second argument is true, error messages if verbose
"""
function isautogram(txt, countpunctuation; verbose = true)
    s = lowercase(txt)
    charcounts = counter(s)
    stillneedmention = Dict(p[1] => isletter(p[1]) || p[1] != ' ' && countpunctuation ? p[2] : 0 for p in charcounts)
    s = " " * replace(s, r"^\.(?:employs|composed|contains)" => "")
    for mention in split(s, r"\s*,|:\s*")
        mention = replace(mention, r" and$" => "")
        spos = findlast(isspace, mention)
        numfromtext = phrasetointeger(mention[begin:spos-1])
        numfromtext == 0 && continue
        c = mention[begin+spos:end]
        if c == "letters"
            if numfromtext != count(isletter, txt)   # verify a total letter count
                verbose && println("The total letter count (should be $(count(isletter, txt))) is incorrect.")
                return false
            end
            continue
        end
        ch = contains(c, "comma") ? ',' : contains(c, "apostrophe") ? '\'' : contains(c, "hyphen") ? '-' : Char(c[1])
        if charcounts[ch] == numfromtext   # verify an individual character count
            stillneedmention[ch] = 0
        else
            verbose && println("The count of $ch in the phrase is incorrect.")
            return false
        end
    end
    for p in stillneedmention
        if p[2] > 0  # a letter we counted was not counted by the sentence
            verbose && println("The letter and count $p was not mentioned in the counts in the phrase.")
            return false
        end
    end
    return true
end

for (i, t) in enumerate([
    ("This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.", false),
    ("This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.", false),
    ("Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !", true),
    ("This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.", false),
    ("This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.", false),
    ("Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.", false),
    ("Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.", true),
    ("Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's.", false),
   ])
    println("Test phrase $i is", isautogram(t[1], t[2]) ? " " : " not ", "a valid autogram.\n")
end
