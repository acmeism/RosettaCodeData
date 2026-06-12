// Count how many vowels and consonants occur in a string. Nigel Galloway: August 1th., 202
type cType = Vowel |Consonant |Other
let fN g=match g with 'a'|'e'|'i'|'o'|'u'->Vowel |g when System.Char.IsLetter g->Consonant |_->Other
let n="Now is the time for all good men to come to the aid of their country."|>Seq.countBy(System.Char.ToLower>>fN)
printfn "%A" n
