input   ← {⍞←'Guess: ' ⋄ 7↓⍞}
output  ← {⎕←(↑'Bulls: ' 'Cows: '),⍕⍪⍵ ⋄ ⍵}
isdigits← ∧/⎕D∊⍨⊢
valid   ← isdigits∧4=≢
guess   ← ⍎¨input⍣(valid⊣)
bulls   ← +/=
cows    ← +/∊∧≠
game    ← (output ⊣(bulls,cows) guess)⍣(4 0≡⊣)
random  ← 1+4?9
moo     ← 'You win!'⊣(random game⊢)
