⍝⍝⍝⍝ Utility functions

⍝ convert to uppercase
UpCase ← { 1 ⎕C ⍵ }

⍝ remove non-letters
JustLetters ← { ⍵ /⍨ ⍵∊⎕A }

⍝ replace 'J's with 'I's
ReplaceJ ← { ('J' ⎕R 'I') ⍵ }

⍝ Insert an 'X' between repeated letters
SplitDouble ← { (' '⎕R'X') ⍵ \⍨ 1,~⍵=1⌽⍵ }

⍝ Append an 'X' if the message is not of even length
PadEven ← { ⍵,(2|≢⍵) ⍴ 'X' }

⍝ Split text up into letter pairs
Pairs ← { (1=2|⍳≢⍵) ⊂ ∊ ⍵ }

⍝ Group text into chunks of five letters
Groups ← { (1=5|⍳≢⍵) ⊂ ∊ ⍵ }

⍝ Shift within 1-5 based on left arg (0 for +1,1 for -1)
Shift ← { ⍺ ← 0 ⋄ 1+5|(⍺+1)⌷⍵,3+⍵ }

⍝⍝⍝⍝ Playfair implementation

⍝ All the things we have to do to the plaintext, chained together
PreparePlaintext ← { PadEven SplitDouble ReplaceJ JustLetters UpCase ∊ ⍵ }

⍝ Ditto for ciphertext
PrepareCiphertext ← { JustLetters UpCase ∊ ⍵ }

⍝ Create the grid from the key
PrepareKey ← { 5 5⍴ ∪ ReplaceJ (JustLetters UpCase ⍵),⎕A }

⍝ Encode or decode a single pair of letters
∇resultPair ← grid TransformPair args;mode;inPair;l;r;i1;j1;i2;j2
 mode inPair ← args
 l r ← inPair
 i1 j1 ← ⊃⍸grid=l
 i2 j2 ← ⊃⍸grid=r
 :If i1=i2
     j1 ← mode Shift j1
     j2 ← mode Shift j2
 :Else
     :If j1=j2
         i1 ← mode Shift i1
         i2 ← mode Shift i2
     :Else
         j1 j2 ← j2 j1
     :EndIf
 :EndIf
 resultPair ← grid[(i1 j1)(i2 j2)]
∇

⍝ Encode or decode an entire message
∇resultText ← grid TransformText args; mode; inText
  mode inText ← args
  resultText ← Groups ∊ { grid TransformPair mode ⍵ } ¨ Pairs inText
∇

⍝ Specific transforms for each direction including key and text preparation
∇cipher ← key EncodeText plain
  cipher ← (PrepareKey key) TransformText 0 (PreparePlaintext plain)
∇

∇plain ← key DecodeText cipher
  plain ← (PrepareKey key) TransformText 1 (PrepareCiphertext cipher)
∇

⍝ Demo
key ← 'Playfair example'
plain ← 'Hide the gold in the tree stump.'
⎕ ← cipher ← key EncodeText plain
⎕ ← key DecodeText cipher
