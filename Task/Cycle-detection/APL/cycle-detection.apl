brent←{
    f←⍺⍺
    lam←⊃{
        l p t h←⍵
        p=l: 1 (p×2) h (f h) ⋄ (l+1) p t (f h)
    }⍣{=/2↓⍺} ⊢ 1 1 ⍵ (f ⍵)
    mu←⊃{
        (⊃⍵+1),f¨1↓⍵
    }⍣{=/1↓⍺} ⊢ 0 ⍵ (f⍣lam⊢⍵)
    mu lam
}

task←{
    seq←{f←⍺⍺ ⋄ (⊃⍺)↓{⍵,f⊃⌽⍵}⍣(1-⍨+/⍺)⊢⍵}
    ⎕←0 20 ⍺⍺ seq ⍵                    ⍝ First 20 elements
    ⎕←(↑'Index' 'Length'),⍺⍺ brent ⍵   ⍝ Index and length of cycle
    ⎕←(⍺⍺ brent ⍺⍺ seq⊢)⍵              ⍝ Cycle
}

(255 | 1 + ⊢×⊢) task 3
