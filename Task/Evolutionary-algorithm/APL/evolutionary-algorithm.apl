 evolve←{
    ⍺←0.1
    target←'METHINKS IT IS LIKE A WEASEL'
    charset←27↑⎕A
    fitness←{target+.=⍵}
    mutate←⍺∘{
       (⍺>?(⍴target)/0){
          ⍺:(?⍴charset)⊃charset
          ⍵
       }¨⍵
    }
    ⍵{
       target≡⎕←⍵:⍵
       next←mutate¨⍺/⊂⍵
       ⍺∇(⊃⍒fitness¨next)⊃next
    }charset[?(⍴target)/⍴charset]
 }
