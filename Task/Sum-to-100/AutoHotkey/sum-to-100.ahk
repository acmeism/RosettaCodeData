output:=""
for k, v in (sum2num(100))
    output .= k "`n"
MsgBox, 262144, , % output

mx := []
loop 123456789{
    x := sum2num(A_Index)
    mx[x.Count()] := mx[x.Count()] ? mx[x.Count()] ", " A_Index : A_Index
}
MsgBox, 262144, , % mx[mx.MaxIndex()] " has " mx.MaxIndex() " solutions"

loop {
    if !sum2num(A_Index).Count(){
        MsgBox, 262144, , % "Lowest positive sum that can't be expressed is " A_Index
        break
    }
}
return

sum2num(num){
    output := []
    loop % 6561
    {
        oper := SubStr("00000000" ConvertBase(10, 3, A_Index-1), -7)
        oper := StrReplace(oper, 0, "+")
        oper := StrReplace(oper, 1, "-")
        oper := StrReplace(oper, 2, ".")
        str := ""
        loop 9
            str .= A_Index . SubStr(oper, A_Index, 1)
        str := StrReplace(str, ".")
        loop 2
        {
            val := 0
            for i, v in StrSplit(str, "+")
                for j, m in StrSplit(v, "-")
                    val += A_Index=1 ? m : 0-m
            if (val = num)
                output[str] := true
            str := "-" str
        }
    }
    Sort, output
    return output
}

; https://www.autohotkey.com/boards/viewtopic.php?p=21143&sid=02b9c92ea98737f1db6067b80a2a59cd#p21143
ConvertBase(InputBase, OutputBase, nptr){
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    VarSetCapacity(s, 66, 0)
    value := DllCall("msvcrt.dll\" u, "Str", nptr, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}
