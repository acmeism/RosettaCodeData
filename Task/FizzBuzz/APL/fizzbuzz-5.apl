    ∇ sv ← fizzbuzz n; t;d
[1]   ⍝⍝ Solve the popular 'fizzbuzz' problem in APL.
[2]   ⍝⍝ \param n - highest number to compute (≥0)
[3]   ⍝⍝ \returns sv - a vector of strings representing the fizzbuzz solution for ⍳n
[4]   ⍝⍝     (note we return a string vector to avoid a mixed-type result; remove the
[5]   ⍝⍝     ⍕ function from the (⍕t[⍵]) term to see the difference).
[6]   ⍝⍝⍝⍝
[7]   t←⍳n   ⍝ the sequence 1..n itself which we'll pick from
[8]   ⍝  ... or the words 'fizz', 'buzz', 'fizzbuzz' depending on
[9]   ⍝  ... divisibility by 3 and/or 5
[10]  ⍝⎕←t   ⍝ (Uncomment to see during call)
[11]
[12]  d←1+(+⌿ ⊃ {((0=3|⍵)) (2×(0=5|⍵))} ⍳n)
[13]  ⍝ || || | |                     | ↓↓
[14]  ⍝ || || | |                     | ⍳n: generate range (1..n)
[15]  ⍝ || || | ↓.....................↓                 ↓↓
[16]  ⍝ || || | A dfn (lambda) taking its right arg (⍵, ⍳n here) to compute two boolean
[17]  ⍝ || || |   vectors(v12): divisibility by 3 and 5, respectively, for each of ⍳n
[18]  ⍝ || || ↓
[19]  ⍝ || || ⊃: Disclose ('lift-up' and pad w/zeros) the 'ragged' matrix of vectors (v12)
[20]  ⍝ || ||    holding divisibility by 3 and 5 of each ⍳n
[21]  ⍝ || ↓↓
[22]  ⍝ || +⌿: Sum (v12) row-wise to count divisibility (0=neither 3 nor 5, 1=3, 2=3 and 5)
[23]  ⍝ ↓↓
[24]  ⍝ 1+: Add one to (v12) to make them 1-based for indexing below:
[25]  ⍝⎕←d
[26]
[27]  sv ← { ((⍕t[⍵]) 'Fizz' 'Buzz' 'FizzBuzz') [d[⍵]]}¨ ⍳n
[28]  ⍝    | |                                | |    | |
[29]  ⍝    | |                                | ↓....↓ |
[30]  ⍝    | |................................↓  idx   |
[31]  ⍝    | (      lookup output vector      )        |
[32]  ⍝    ↓...........................................↓
[33]  ⍝    A dfn (lambda) taking as its right arg (⍵) ⍳n and using the 'each' (¨)
[34]  ⍝      operator to apply the lambda to each (idx) of ⍳n.
[35]
[36]  ⍝⍝ USAGE
[37]  ⍝⍝ ⎕ ← ,fizzbuzz 15
[38]  ⍝ 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz
    ∇
