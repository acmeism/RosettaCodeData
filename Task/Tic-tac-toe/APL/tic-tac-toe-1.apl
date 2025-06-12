⎕IO←0 ⋄ t←1∘↑ ⋄ b←1∘↓ ⋄ c←{Z[?≢Z←⍸0=⍵]}                        ⍝ extract turn/board; cpu's move
y←{3::∇⍵⊣⎕←'no' ⋄ ⍞←'move (1-9): ' ⋄ 0=⍵[p←⍎12↓⍞]: p ⋄ 2⌷0 0}  ⍝ your move
m←{((-,⊢)t⍵)@(0,{1=t⍵: y⍵ ⋄ c⍵}⍵)⊢⍵}                           ⍝ apply current player's move to board
w←{∨/3=|+/(0 0⍉B)⍪(0 0⍉⌽B)⍪B⍪⍉B←3 3⍴b⍵}                        ⍝ has game been won?
d←{⍵⊣⎕←' '⍪' '⍪⍨↑(⊣,' ',⊢)/3 3⍴'.XO'[0 1 ¯1⍳b⍵]}               ⍝ display board
o←{0∊b⍵: 'XO'[1=t⍵],' wins' ⋄ 'tie'}                           ⍝ determine and print game outcome
g←{o d∘m⍣((w∨0~⍤∊b)⊣)10↑¯1}                                    ⍝ game; move & display until won or full
