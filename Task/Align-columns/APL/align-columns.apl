align←{
    left ← {⍺↑⍵}
    right ← {(-⍺)↑⍵}
    center ← {⍺↑(-⌊(≢⍵)+(⍺-≢⍵)÷2)↑⍵}
    text ← ⊃⎕NGET⍵
    words ← ((≠∘'$')⊆⊣)¨(~text∊⎕TC)⊆text
    sizes ← 1+⌈⌿↑≢¨¨words
    method ← ⍎⍺
    ↑,/↑(⊂sizes)method¨¨↓↑words
}
