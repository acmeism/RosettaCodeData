oldLady←{
    N←⎕TC[3]
    a←'fly' 'spider' 'bird' 'cat' 'dog' 'goat' 'cow' 'horse'
    v←⊂'I don''t know why she swallowed that fly - Perhaps she''ll die',N
    v←v,⊂'That wiggled and jiggled and tickled inside her!'
    v←v,⊂'How absurd to swallow a bird'
    v←v,⊂'Imagine that! She swallowed a cat!'
    v←v,⊂'What a hog to swallow a dog'
    v←v,⊂'She just opened her throat and swallowed that goat'
    v←v,⊂'I don''t know how she swallowed that cow'
    v←v,⊂'She''s dead, of course.'
    l←'There was an old lady who swallowed a '
    ∊{
        ∊l,a[⍵],N,v[⍵],N,(⍵<8)/{
            ⍵=0:''
            r←'She swallowed the ',a[⍵],' to catch the ',a[⍵-1],N
            r,(⍵≤3)/v[⍵-1],N
        }¨⌽1↓⍳⍵
    }¨⍳8
}
