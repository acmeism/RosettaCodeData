erdos_primes←{
    prime ← {(⍵≥2) ∧ 0∧.≠(1↓⍳⌊⍵*÷2)|⍵}
    erdos ← {(prime ⍵) ∧ ∧/~prime¨ ⍵-!⍳⌊(!⍣¯1)⍵}
    e2500 ← (erdos¨e)/e←⍳2500
    ⎕←e2500
    ⎕←'There are ',(⍕⍴e2500),' Erdős numbers ≤ 2500'
}
