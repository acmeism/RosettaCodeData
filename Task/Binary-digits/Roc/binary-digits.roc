binstr : Int * -> Str
binstr = \n ->
    if n < 2 then
        Num.toStr n
    else
        Str.concat (binstr (Num.shiftRightZfBy n 1)) (Num.toStr (Num.bitwiseAnd n 1))
