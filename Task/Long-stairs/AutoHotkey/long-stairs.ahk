result := "Sec    steps behind    steps ahead"
x := longStairs(609)
for i, s in x.4
    result .= "`n" i+599 "`t" s "`t`t" x.2 - s
tests := 10000
loop % tests
{
    x := longStairs()
    totSteps += x.1
    totSec += x.3
}
MsgBox, 262144, , % result .= "`n`nAfter " tests " tests:`nAverage time taken = " totSec/tests " Sec"
        .    "`nAverage Stair length = " totSteps/tests " steps"
return

longStairs(t:=0){
    Stairs := [], last10Steps := [], s := 0
    loop 100
        Stairs[A_Index] := 0
    loop
    {
        Stairs[++s] := "S"                        ; take a step forward
        if (last10Steps.count()>=10)
            last10Steps.RemoveAt(1)
        last10Steps.push(s)
        loop 5                                    ; add 5 steps to stairs
        {
            Random, stp, 1, % Stairs.Count()
            Stairs.InsertAt(stp, "x")
            s += s > stp ? 1 : 0
        }
        escT := s = Stairs.Count() ? A_Index : 0
        if (A_Index = t || escT)                  ; reached time limit or Escaped
            break
    }
    return [s, Stairs.Count(), escT, last10Steps]
}
