fusc:=[], fusc[0]:=0, fusc[1]:=1, n:=1, l:=0, result:=""

while (StrLen(fusc[n]) < 5)
    fusc[++n] := Mod(n, 2) ? fusc[floor((n-1)/2)] + fusc[Floor((n+1)/2)] : fusc[floor(n/2)]

while (A_Index <= 61)
    result .= (result = "" ? "" : ",") fusc[A_Index-1]

result .= "`n`nfusc number whose length is greater than any previous fusc number length:`nindex`tnumber`n"
for i, v in fusc
    if (l < StrLen(v))
        l := StrLen(v), result .= i "`t" v "`n"

MsgBox % result
