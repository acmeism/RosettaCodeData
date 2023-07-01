anagrams←{
    tie←⍵ ⎕NTIE 0
    dict←⎕NREAD tie 80(⎕NSIZE tie)0
    boxes←((⎕UCS 10)≠dict)⊆dict
    ana←(({⍵[⍋⍵]}¨boxes)({⍵}⌸)boxes)
    ({~' '∊¨(⊃/¯1↑[2]⍵)}ana)⌿ana ⋄ ⎕NUNTIE
}
