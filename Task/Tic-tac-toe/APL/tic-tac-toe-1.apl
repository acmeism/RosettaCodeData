{⎕IO B T W WM←0(9⍴0)¯1 0(7 56 448 73 146 292 273 84⊤⍨9⍴2)  ⍝ board; turn; win flag; winning trios
 _←{B[{1=T:{3::∇⊣⎕←'no'⋄⍞←'move (1-9): '                   ⍝ your move
            B[P←¯1+⍎12↓⍞]=0:P⋄2⌷0 0}⍬
           Z[?≢Z←⍸0=B]}⍬]⊢←T⋄T⊢←-T                         ⍝ cpu's move; switch turn
    ⊣⎕←' '⍪⍨↑(⊣,' ',⊢)/3 3⍴'.XO'[0 1 ¯1⍳B]                 ⍝ show board
   }⍣{(~0∊B)∨W⊢←∨/3=|B+.∧WM}⍬                              ⍝ repeat until won or full
   W:'XO'[1=T],' wins'⋄'tie'}⍬                             ⍝ print result
