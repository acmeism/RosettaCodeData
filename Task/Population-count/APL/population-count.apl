 APL (DYALOG APL)
 popDemo←{⎕IO←0
     N←⍵
   ⍝ popCount: Does a popCount of integers (8-32 bits) or floats (64-bits) that can be represented as integers
     popCount←{
         i2bits←{∊+/2⊥⍣¯1⊣⍵}  ⍝ Use ⊥⍣¯1 (inverted decode) for ⊤ (encode) to automatically detect nubits needed
         +/i2bits ⍵           ⍝ Count the bits
     }¨

     act3←popCount 3*⍳N

     M←N×2
     actEvil←N↑{⍵/⍨0=2|popCount ⍵}⍳M
     actOdious←N↑{⍵/⍨1=2|popCount ⍵}⍳M

     ⎕←'powers 3'act3
     ⎕←'evil    'actEvil
     ⎕←'odious  'actOdious

   ⍝ Extra: Validate answers are correct
   ⍝    Actual answers
     ans3←1 2 2 4 3 6 6 5 6 8 9 13 10 11 14 15 11 14 14 17 17 20 19 22 16 18 24 30 25 25
     ansEvil←0 3 5 6 9 10 12 15 17 18 20 23 24 27 29 30 33 34 36 39 40 43 45 46 48 51 53 54 57 58
     ansOdious←1 2 4 7 8 11 13 14 16 19 21 22 25 26 28 31 32 35 37 38 41 42 44 47 49 50 52 55 56 59

     '***Passes' '***Fails'⊃⍨(ans3≢act3)∨(actEvil≢ansEvil)∨(actOdious≢ansOdious)
 }
