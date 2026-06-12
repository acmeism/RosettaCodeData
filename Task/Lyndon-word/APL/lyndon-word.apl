 LyndonWords←{
     ⍝ Implements Duval's algorithm for generating Lyndon words
     ⍝ ⍺: alphabet (default Binary)
     ⍝ ⍵: max length of Lyndon words to generate
     ⍝ ←: all Lyndon words up to length ⍵
     ⎕IO←1
     ⍺←'01'
     alphabet←⍺
     z←≢alphabet    ⍝ Mnemonic: z is the last letter of the alphabet
     length←⍵
     result←''

     Generate←{
         0∊⍴⍵:result                        ⍝ No more words to find: return result
         next←1+@(≢⍵)⊢⍵                     ⍝ Increment last non-z symbol
         result,←⊂alphabet[next]            ⍝ Append word to result
         ∇ word↓⍨-+/∧\⌽z=word←length⍴next   ⍝ Repeat word to max length and drop trailing zs
     }

     ⍝ This seed means the first word generated will be ,1
     ⍝ (the word containing only the first symbol of the alphabet)
     Generate,0
 }

 LyndonWords 5
