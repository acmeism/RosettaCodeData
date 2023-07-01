 sudan←{
    0∨.>⍺ ⍺⍺ ⍵:'Negative input'⎕SIGNAL 11
    ⍺⍺=0:⍺+⍵
    ⍵=0:⍺
    tm((⍺⍺-1)∇∇)⍵+tm←⍺∇⍵-1
 }
