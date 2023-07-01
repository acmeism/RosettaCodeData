    a←'abcdefghijklmnopqrstuvwxyz' ⍝ or ⎕ucs 96 + ⍳26 in GNU/Dyalog
    A←'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ⍝ or ⎕ucs 64 + ⍳26, or just ⎕a in Dyalog

    Pangram ← {∧/ ∨⌿ 2 26⍴(a,A) ∊ ⍵}
    Pangram 'This should fail'
0
    Pangram 'The quick brown fox jumps over the lazy dog'
1
