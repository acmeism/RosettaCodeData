∇HexWords;todec;digroot;displayrow;words;distinct4
todec←16⊥9+'abcdef'∘⍳
digroot←(+/10⊥⍣¯1⊢)⍣(10≥⊢)
displayrow←{⍵ n (digroot⊢n←todec ⍵)}

words←((~∊)∘⎕TC⊆⊢)⊃⎕NGET'unixdict.txt'
words←(words∧.∊¨⊂⊂'abcdef')/words
words←(4≤≢¨words)/words
words←words[⍋digroot∘todec¨words]

distinct4←(4≤≢∘∪¨words)/words
distinct4←distinct4[⍒todec¨distinct4]

⎕←(⍕≢words),' hex words with at least 4 letters in unixdict.txt:'
⎕←↑displayrow¨words
⎕←''

⎕←(⍕≢distinct4),' hex words with at least 4 distinct letters:'
⎕←↑displayrow¨distinct4
∇
