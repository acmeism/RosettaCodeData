 unescape←{
    de←{⎕SIGNAL⊂('EN'11)('Message'(∊⍵))}
    his←≥∘55296∧≤∘56319
    los←≥∘56320∧≤∘57343
    hex←{
        16∧.>c←¯1+(16↑⎕D,⎕A)⍳1⎕C⍵:16⊥c
        de'Invalid hexadecimal digit: ',⍵
    }
    0=≢⍵:⍵
    '\'≠c←⊃⍵:c,∇1↓⍵
    9>i←'"\/bfnrt'⍳t←⊃1↓⍵:(⎕UCS 34 92 47 8 12 10 13 9[i]),∇2↓⍵
    'u'≠t:t,∇2↓⍵
    6>≢⍵:de'Incomplete escape sequence'
    (los⍱his)m←hex 2↓6↑⍵:(⎕UCS m),∇6↓⍵
    '\u'≢2↑nx←6↓⍵:de'Lone ',('low' 'high'[1+his m]),' surrogate'
    6>≢nx:de'Incomplete escape sequence'
    (los⍱his)t←hex 2↓6↑nx:de'Low' 'High'[1+his m],' surrogate followed by non-surrogate'
    (los⍲.∨his)m t:de'Invalid surrogate pair'
    m t←⌽⍣(los m)⊢m t
    (⎕UCS 65536+(1024×m-55296)+t-56320),∇12↓⍵
}
