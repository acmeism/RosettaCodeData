list := ["abcd","123456789","abcdef","1234567"]

sorted := []
for i, s in list
    sorted[0-StrLen(s), s] := s
for l, obj in sorted
{
    i := A_Index
    for s, v in obj
    {
        if (i = 1)
            result .= """" s """ has length " 0-l " and is the longest string.`n"
        else if (i < sorted.Count())
            result .= """"s """ has length " 0-l " and is neither the longest nor the shortest string.`n"
        else
            result .= """"s """ has length " 0-l " and is the shorted string.`n"
    }
}
MsgBox % result
