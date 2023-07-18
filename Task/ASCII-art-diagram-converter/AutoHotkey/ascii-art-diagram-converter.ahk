Header := "
(LTrim
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      ID                       |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    QDCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ANCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    NSCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ARCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
)"

Data := "78477BBF5496E12E1BF169A4"
MsgBox % result := ASCII_art_diagram_converter(Header, Data)
return

ASCII_art_diagram_converter(Header, Data){
    oDataBin := []
    for i, h in StrSplit(Data)
        for i, v in StrSplit(SubStr("0000" . ConvertBase(16, 2, h), -3))
            oDataBin.Push(v)

    bitWidth := StrLen(StrSplit(Header, "+").2) + 1
    prevW := 0
    result := "Name`t`tSize`tBinary"
    for i, line in StrSplit(Header, "`n", "`r")
    {
        if Mod(A_Index, 2)
            continue
        strtPos := 0
        loop
        {
            if w := (strtPos := InStr(line, "|",, ++strtPos)) // bitWidth
            {
                b := ""
                loop % width := w - prevW
                    b .= oDataBin.RemoveAt(1)
                result .= "`n" Trim(StrSplit(line, "|")[A_Index]) "`t`t" width . "`t" b
            }
            prevW := w
        }
        until !strtPos
    }
    return result
}

ConvertBase(InputBase, OutputBase, nptr){ ; Base 2 - 36 ; https://www.autohotkey.com/boards/viewtopic.php?t=3925#p21143
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    VarSetCapacity(s, 66, 0)
    value := DllCall("msvcrt.dll\" u, "Str", nptr, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}
