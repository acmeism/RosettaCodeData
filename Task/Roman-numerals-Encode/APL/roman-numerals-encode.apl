toRoman←{
    ⍝ Digits and corresponding values
    ds←((⊢≠⊃)⊆⊢)' M CM D CD C XC L XL X IX V IV I'
    vs←1000, ,100 10 1∘.×9 5 4 1
    ⍝ Input ≤ 0 is invalid
    ⍵≤0:⎕SIGNAL 11
    {   0=d←⊃⍸vs≤⍵:⍬    ⍝ Find highest digit in number
        (d⊃ds),∇⍵-d⊃vs  ⍝ While one exists, add it and subtract from number
    }⍵
}
