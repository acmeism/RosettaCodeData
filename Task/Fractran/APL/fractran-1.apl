fractran←{
    parts ← ' '∘≠⊆⊢
    frac ← ⍎¨'/'∘≠⊆⊢
    simp ← ⊢÷∨/
    mul ← simp×
    prog ← simp∘frac¨parts ⍺
    step ← {⊃⊃(1=2⊃¨next)/next←⍺ mul¨⊂(⍵ 1)}
    (start nstep)←⍵
    rslt ← ⊃(⊢,⍨prog∘step∘⊃)⍣nstep¨start
    ⌽(⊢(/⍨)(∨\0∘≠))rslt
}
