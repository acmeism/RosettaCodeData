wordwheel←{
    words←((~∊)∘⎕TC⊆⊢) 80 ¯1⎕MAP ⍵
    match←{
        0=≢⍵:1
        ~(⊃⍵)∊⍺:0
        ⍺[(⍳⍴⍺)~⍺⍳⊃⍵]∇1↓⍵
    }
    middle←(⌈0.5×≢)⊃⊢
    words←((middle ⍺)∊¨words)/words
    words←(⍺∘match¨words)/words
    (⍺⍺≤≢¨words)/words
}
