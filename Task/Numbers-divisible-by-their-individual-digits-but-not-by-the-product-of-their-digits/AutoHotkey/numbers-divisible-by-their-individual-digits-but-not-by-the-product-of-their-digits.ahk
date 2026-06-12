main:
while n < 1000
{
    n := A_Index
    prod = 1
    for i, v in StrSplit(n)
    {
        if (v = 0) || (n/v <> floor(n/v))
            continue, main
        prod *= v
    }
    if (n/prod = floor(n/prod))
        continue
    result .= n "`t"
}
MsgBox % result
