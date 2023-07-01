bell←{
    tr←↑(⊢,(⊂⊃∘⌽+0,+\)∘⊃∘⌽)⍣14⊢,⊂,1
    ⎕←'First 15 Bell numbers:'
    ⎕←tr[;1]
    ⎕←'First 10 rows of Bell''s triangle:'
    ⎕←tr[⍳10;⍳10]
}
