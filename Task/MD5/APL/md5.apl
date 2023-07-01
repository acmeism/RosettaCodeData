 md5←{
     ⍝ index origin zero
     ⎕IO←0
     ⍝ decoding UTF-8 & padding
     M←(⊢,(0⍴⍨512|448-512|≢))1,⍨l←,⍉(8⍴2)⊤'UTF-8'⎕UCS ⍵
     ⍝ add length
     M,←,⍉(8⍴2)⊤⌽(8⍴256)⊤≢l
     ⍝ init registers
     A←16⊥6 7 4 5 2 3 0 1
     B←16⊥14 15 12 13 10 11 8 9
     C←16⊥9 8 11 10 13 12 15 14
     D←16⊥1 0 3 2 5 4 7 6
     ⍝ T table
     T←⌊(2*32)×|1○1+⍳64
     ⍝ index table
     K←16|i,(1+5×i),(5+3×i),7×i←⍳16
     ⍝ rot table
     S←,1 0 2⍉4 4 4⍴7 12 17 22 5 9 14 20 4 11 16 23 6 10 15 21
     ⍝ truncate ⍵ to 32 bit & rot left ⍺
     rot←{2⊥⍺⌽(32⍴2)⊤⍵}
     proc←{
         ⍝ pack 512 bits into 32 bit words &
         ⍝ precompute X[k] + T[i]
         l←T+(⊂K)⌷256⊥⍉⌽16 4⍴2⊥⍉64 8⍴⍺
         fn←{
         ⍝ a b c d to binary
             a b c d←↓⍉(32⍴2)⊤⍵
         ⍝ a + F(b,c,d)
             ⍺<16:S[⍺]rot l[⍺]+2⊥a+d≠b∧c≠d
             ⍺<32:S[⍺]rot l[⍺]+2⊥a+(b∧d)∨(c∧~d)
             ⍺<48:S[⍺]rot l[⍺]+2⊥a+b≠c≠d
             S[⍺]rot l[⍺]+2⊥a+c≠b∨~d
         }
         (2*32)|⍵+⊃{¯1⌽((⍵[1]+⍺ fn ⍵)@0)⍵}/(⌽⍳64),⊂⍵
     }
     ⍝ process each 512 bits
     loop←{⍬≡⍺:⍵ ⋄ (512↓⍺)∇(512↑⍺)proc ⍵}
     ⍝ output registers
     (⎕D,⎕A)[,⍉(2⍴16)⊤,⍉⊖(4⍴256)⊤M loop A B C D]
 }
