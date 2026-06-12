coins := [1, 2, 5, 10, 20, 50, 100, 200]
val := 988

result := ""
while val
{
    coin := coins.pop()
    if (val//coin)
        result .= val//coin " * " coin "`n", val -= val//coin * coin
}
MsgBox, 262144, , % result
return
