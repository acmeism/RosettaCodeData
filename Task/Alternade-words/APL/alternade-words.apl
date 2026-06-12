alternade←{
    ⍺←6
    parts←{(⊂k/⍵),⊂(~k←2|⍳≢⍵)/⍵}
    check←∊∘(words←(~words∊⎕TC)⊆words←⊃⎕NGET⍵)
    long←(⍺≤≢¨words)/words
    ↑(⊂,parts)¨(∧/∘check∘parts¨long)/long
}
