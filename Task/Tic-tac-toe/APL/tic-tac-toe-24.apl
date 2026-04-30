⎕IO B WM←0(2 9⍴0)(7 56 448 73 146 292 273 84⊤⍨9⍴2)          ⍝ the board and winning trios
{_←{~⍵:{3::∇⊣⎕←'no'⋄⍞←'move (1-9): '                        ⍝ your move
        (∨⌿B)[M←¯1+⍎12↓⍞]:2⌷0 0⋄B[0;M]⊢←1}⍬
       B[1;Z[?≢Z←⍸~∨⌿B]]⊢←1}⍵                               ⍝ cpu's move
 _←{⎕←↑(⊣,' ',⊢)/⎕AV[3 3⍴⌈⌿(⎕AV⍳'.XO')×⍤¯1⊢B⍪⍨~∨⌿B]}⍣⍵⊢⍬    ⍝ show board after each cpu move
 W←∨/3=|B[⍵;]+.∧WM⋄F←511=2⊥∨⌿B                              ⍝ test win and full conditions
 _←{⎕OFF⊣⎕←' wins',⍨{W:'XO'[⍵]⋄'the cat'}⍵}⍣(W∨F)⊢⍵         ⍝ when game is over, exit and print winner
 ~⍵}⍣{0}1                                                   ⍝ now it's the other player's turn
