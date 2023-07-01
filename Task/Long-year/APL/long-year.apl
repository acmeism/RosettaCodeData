dec31weekday ← {7|⍵+⌊(⍵÷4)+⌊(⍵÷400)-⌊⍵÷100}
isolongyear ← {(4 = dec31weekday ⍵) ∨ 3 = dec31weekday ⍵ - 1}
