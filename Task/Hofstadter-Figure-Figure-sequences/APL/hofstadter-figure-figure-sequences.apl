:Class HFF
    :Field Private Shared RBuf←,1
    ∇r←ffr n
        :Access Public Shared
        r←n⊃RBuf←(⊢,⊃∘⌽+≢⊃(⍳1+⌈/)~⊢)⍣(0⌈n-≢RBuf)⊢RBuf
    ∇
    ∇s←ffs n;S
        :Access Public Shared
        :Repeat
            S←((⍳1+⌈/)~⊢)RBuf
            :If n≤≢S ⋄ :Leave ⋄ :EndIf
            S←ffr 1+≢RBuf
        :EndRepeat
        s←n⊃S
    ∇
    ∇Task;th
        :Access Public Shared
        ⎕←'R(1 .. 10):', ffr¨⍳10
        :If (⍳1000) ∧.∊ ⊂th←(ffr¨⍳40) ∪ (ffs¨⍳960)
            ⎕←'1..1000 ∊ (ffr 1..40) ∪ (ffs 1..960)'
        :Else
            ⎕←'Missing values: ', (⍳1000)~th
        :EndIf
    ∇
:EndClass
