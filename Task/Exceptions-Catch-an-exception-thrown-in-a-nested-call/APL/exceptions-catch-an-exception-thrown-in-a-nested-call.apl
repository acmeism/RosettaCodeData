:Namespace Traps
    ⍝ Traps (exceptions) are just numbers
    ⍝ 500-999 are reserved for the user
    U0 U1←900 901

    ⍝ Catch
    ∇foo;i
        :For i :In ⍳2
            :Trap U0
                bar i
            :Else
                ⎕←'foo caught U0'
            :EndTrap
        :EndFor
    ∇

    ⍝ Throw
    ∇bar i
        ⎕SIGNAL U0 U1[i]
    ∇
:EndNamespace
