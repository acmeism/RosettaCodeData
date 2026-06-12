grammar VOWCON {
    token       TOP { <|w> <vowel>? ( <consonant> <vowel> )* <consonant>? <|w> }
    token     vowel { <[aeiou]> }
    token consonant { <[a..z] - [aeiou]> }
}

say ( grep { VOWCON.parse: .lc }, grep { .chars > 9 }, 'unixdict.txt'.IO.words ).batch(6)».fmt('%-15s').join: "\n";
