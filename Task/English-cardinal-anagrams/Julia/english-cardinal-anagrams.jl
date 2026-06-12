import SpelledOut: spelled_out
import Counters: counter

languages = Dict("English" => :en, "Spanish" => :es, "Portuguese" => :pt_BR)

""" remove diacritical marks, as anagrams use only standard alphabet """
undiacritical(s) = replace(replace(replace(s, r"[éêé]" => "e"), "ã" => "a"), r"[óõ]" => "o")

""" get the letter frequencies as an anagram representation of string str """
function anarep(str)
    s = undiacritical(lowercase(str))
    return [count(c, s) for c in 'a':'z'] # ignores spaces, hyphens, capitalization
end

""" task at rosettacode.org/wiki/English_cardinal_anagrams """
function process_task(maxrange, showfirst30, lang = "English")
    numstrings = map(n -> spelled_out(n, lang=languages[lang]), 0:maxrange)
    numreps = map(anarep, numstrings)
    anadict = counter(numreps)
    counts = [anadict[numreps[i]] for i in 1:maxrange]
    if showfirst30
        println("First 30 $lang cardinal anagrams:")
        i, printed = 1, 0
        while i < maxrange && printed < 30
            if counts[i] > 1
                printed += 1
                print(rpad(i, 4), printed % 10 == 0 ? "\n" : "")
            end
            i += 1
        end
    end
    print("\nCount of $lang cardinal anagrams up to $maxrange: ")
    println(count(values(anadict) .> 1))
    println("\nLargest group(s) of $lang cardinal anagrams up to $maxrange:")
    maxcount = maximum(counts)
    for r in unique([numreps[i] for i in 1:maxrange if counts[i] == maxcount])
        println(findall(==(r), numreps))
    end
end

process_task(1000, true)
process_task(10000, false)
process_task(10000, false, "Spanish")
process_task(10000, false, "Portuguese")
