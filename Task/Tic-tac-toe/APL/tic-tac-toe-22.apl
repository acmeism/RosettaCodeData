g←{⎕io T←0 ¯1⋄c←{Z[?≢Z←⍸0=⍵]}                            ⍝ turn; cpu's move
y←{3::∇⊣⎕←'no'⋄⍞←'move (1-9):'⋄0=⍵[p←¯1+⍎12↓⍞]:p⋄2⌷0 0}  ⍝ your move
m←{{⍵⊣T⊢←-T}T@({1=T:y⍵⋄c⍵}⍵)⊢⍵}                          ⍝ apply move to board; switch turn
w←{∨/3=|+/(0 0⍉B)⍪(0 0⍉⌽B)⍪B⍪⍉B←3 3⍴⍵}                   ⍝ has game been won?
d←{⍵⊣⎕←' '⍪⍨↑(⊣,' ',⊢)/3 3⍴'.XO'[0 1 ¯1⍳⍵]}              ⍝ display board
o←{w⍵:'XO'[1=T],' wins'⋄'tie'}                           ⍝ determine game outcome
o d∘m⍣(w⍤⊣∨0~⍤∊⊣)9⍴0}                                    ⍝ move & display until won or full
