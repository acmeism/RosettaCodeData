spell←{⎕IO←0
     small←'' 'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight'
     small,←'nine' 'ten' 'eleven' 'twelve' 'thirteen' 'fourteen'
     small,←'fifteen' 'sixteen' 'seventeen' 'eighteen' 'nineteen'
     teens←'twenty' 'thirty' 'forty' 'fifty' 'sixty' 'seventy'
     teens,←'eighty' 'ninety'
     orders←'m' 'b' 'tr' 'quadr',¨⊂'illion'
     orders←(⊂¨,¨10*6+3×⍳∘≢)orders
     orders←('hundred' 100)('thousand' 1000),orders

     ⍵=0:'zero'
     {  ⍵<0:'minus ',∇-⍵
        ⍵<20:⍵⊃small
        ⍵<100:{
            ty←((⌊⍵÷10)-2)⊃teens
            0=n←10|⍵:ty
            ty,'-',n⊃small
        }⍵
        (⊃⊃∇{
            name size←⍺
            cur n←⍵
            rest←size|n
            n≥size:(⊂cur,(⍺⍺⌊n÷size),' ',name,((0≠rest)↑'')),rest
            (⊂cur),rest
        }/orders,⊂(''⍵)),∇100|⍵
    }⍵
}
