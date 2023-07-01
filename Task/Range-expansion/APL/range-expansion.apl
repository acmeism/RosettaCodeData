range←{
    aplnum←{⍎('¯',⎕D)[('-',⎕D)⍳⍵]}
    ∊{  0::('Invalid range: ''',⍵,'''')⎕SIGNAL 11
        n←aplnum¨(~<\(⊢≠∨\)⍵∊⎕D)⊆⍵
        1=≢n:n
        s e←n
        (s+(⍳e-s-1))-1
    }¨(⍵≠',')⊆⍵
}
