duffinian_numbers←{
    sigma ← +/(⍸0=⍳|⊢)
    duff ← sigma((1=∨)∧⊣>1+⊢)⊢
    ⎕←'First 50 Duffinian numbers:'
    ⎕←5 10⍴(⊢(/⍨)duff¨)⍳220
    ⎕←'First 15 Duffinian triplets:'
    ⎕←(0 1 2∘.+⍨⊢(/⍨)0 1 2(⊃∧.⌽)(⊂duff¨))⍳8500
}
