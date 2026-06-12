consonant(ch) = !(ch in ['a', 'e', 'i', 'o', 'u'])
singlec(consonants) = length(unique(consonants)) == length(consonants)
over10sc(word) = length(word) > 10 && singlec(filter(consonant, word))
mostc(word) = [-length(filter(consonant, word)), word]
const res = sort(map(mostc, filter(over10sc, split(read("unixdict.txt", String), r"\s+"))))
println(length(res), " words found.\n\nWord        Consonants\n----------------------")
foreach(a -> println(rpad(a[2], 16), -a[1]), res)
