floyd←{
    max←⍵×(⍵+1)÷2
    tri←↑(⍳max)⊂⍨(0,⍳max-1)∊+\0,⍳⍵
    wdt←⌈⍀⊖≢∘⍕¨tri
    ↑,/wdt{' ',(-⍺××⍵)↑⍕⍵}¨tri
}
