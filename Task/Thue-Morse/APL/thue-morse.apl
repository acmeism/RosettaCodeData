⍝ generate the first ⍵ elements of the Thue-Morse sequence
tm←{⍵⍴(⊢,~)⍣(⍵≤(⍴⊢))⊢,0}
