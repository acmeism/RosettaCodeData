abcwords←{
    ⍺←'abc'
    words←((~∊)∘⎕TC⊆⊢) 80 ¯1⎕MAP ⍵
    match←∧/∊,2</⍳⍨
    (⍺∘match¨words)/words
}
