lcs←{
     ⎕IO←0
     betterof←{⊃(</+/¨⍺ ⍵)⌽⍺ ⍵}                     ⍝ better of 2 selections
     cmbn←{↑,⊃∘.,/(⊂⊂⍬),⍵}                          ⍝ combine lists
     rr←{∧/↑>/1 ¯1↓[1]¨⊂⍵}                          ⍝ rising rows
     hmrr←{∨/(rr ⍵)∧∧/⍵=⌈\⍵}                        ⍝ has monotonically rising rows
     rnbc←{{⍵/⍳⍴⍵}¨↓[0]×⍵}                          ⍝ row numbers by column
     valid←hmrr∘cmbn∘rnbc                           ⍝ any valid solutions?
     a w←(</⊃∘⍴¨⍺ ⍵)⌽⍺ ⍵                            ⍝ longest first
     matches←a∘.=w
     aps←{⍵[;⍒+⌿⍵]}∘{(⍵/2)⊤⍳2*⍵}                    ⍝ all possible subsequences
     swps←{⍵/⍨∧⌿~(~∨⌿⍺)⌿⍵}                          ⍝ subsequences with possible solns
     sstt←matches swps aps⊃⍴w                       ⍝ subsequences to try
     w/⍨{
         ⍺←0⍴⍨⊃⍴⍵                                   ⍝ initial selection
         (+/⍺)≥+/⍵[;0]:⍺                            ⍝ no scope to improve
         this←⍺ betterof{⍵×valid ⍵/matches}⍵[;0]    ⍝ try to improve
         1=1⊃⍴⍵:this                                ⍝ nothing left to try
         this ∇ 1↓[1]⍵                              ⍝ keep looking
     }sstt
 }
