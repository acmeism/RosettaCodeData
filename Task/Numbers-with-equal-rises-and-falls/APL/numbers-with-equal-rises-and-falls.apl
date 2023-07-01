risefall←{
    ⍝ Determine if a number is in the sequence
    inSeq←0=(+/2(<->)/10(⊥⍣¯1)⊢)

    ⍝ First 200 numbers
    ⎕←'The first 200 numbers are:'
    ⎕←(⊢(/⍨)inSeq¨)⍳404

    ⍝ 10,000,000th number
    ⍝ You can't just make a list that big and filter
    ⍝ it, because that will just get you a WS FULL.
    ⍝ Instead it's necessary to loop over them the old-
    ⍝ fashioned way
    ⍞←'The 10,000,000th number is: '
    ⎕←1e7{⍺=0:⍵-1 ⋄ (⍺-inSeq ⍵)∇ ⍵+1}1
}
