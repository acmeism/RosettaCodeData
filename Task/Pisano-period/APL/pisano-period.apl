pisano_period←{
    prime ← 2∘≤∧0∧.≠1↓⍳∘(⌊*∘0.5)|⊢
    select ← {(⍺⍺¨⍵)/⍵}
    factors ← {⍺←2 ⋄ ⍺≥⍵×⍵:⍬ ⋄ 0=⍺|⍵:⍺,⍺∇⍵÷⍺ ⋄ (⍺+1)∇⍵}

    pisanoPeriod ← {⊃⍸1 0⍷(⊢,⍵|(+/¯2∘↑))⍣(⍵×⍵),0 1}
    pisanoPrime ← {(pisanoPeriod ⍺)×⍺*⍵-1}
    pisano ← {∧/{⍺=0:1 ⋄ ⍺ pisanoPrime ≢⍵}⌸factors ⍵}

    showPisanoPrimes ← {+⎕←⍵'pisanoPrime'⍺'→'(⍵ pisanoPrime ⍺)}¨
    _←2 showPisanoPrimes prime select ⍳15
    ⎕←''
    _←1 showPisanoPrimes prime select ⍳180
    ⎕←''
    ⎕←'pisano ⍵ for integers ''⍵'' from 1 to 180 are:'
    ⎕←pisano¨12 15⍴⍳180
}
