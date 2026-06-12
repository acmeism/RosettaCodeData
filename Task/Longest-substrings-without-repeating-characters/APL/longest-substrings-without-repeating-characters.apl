lswrc←{
    sfx ← ⌽∘,¨,\∘⌽
    wrc ← ⊢(/⍨)⍳∘⍴(∧\=)⍳⍨
    ls ← ⊢(/⍨)(⌈/=⊢)∘(≢¨)
    ls wrc¨ sfx ⍵
}
