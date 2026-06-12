isvowel(c) = c in ['a', 'e', 'i', 'o', 'u', 'A', 'E', "I", 'O', 'U']
isletter(c) = 'a' <= c <= 'z' || 'A' <= c <= 'Z'
isconsonant(c) = !isvowel(c) && isletter(c)

function vccounts(s)
    a = collect(lowercase(s))
    au = unique(a)
    count(isvowel, a), count(isconsonant, a), count(isvowel, au), count(isconsonant, au)
end

function testvccount()
    teststrings = [
        "Forever Julia programming language",
        "Now is the time for all good men to come to the aid of their country."]
    for s in teststrings
        vcnt, ccnt, vu, cu = vccounts(s)
        println("String: $s\n    Vowels: $vcnt (distinct $vu)\n    Consonants: $ccnt (distinct $cu)\n")
    end
end

testvccount()
