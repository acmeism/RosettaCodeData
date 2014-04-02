str := "The quick brown fox jumps over the lazy dog"
MsgBox, % "String:`n" (str) "`n`nCRC32:`n" CRC32(str)



; CRC32 =============================================================================
CRC32(string, encoding = "UTF-8")
{
    chrlength := (encoding = "CP1200" || encoding = "UTF-16") ? 2 : 1
    length := (StrPut(string, encoding) - 1) * chrlength
    VarSetCapacity(data, length, 0)
    StrPut(string, &data, floor(length / chrlength), encoding)
    SetFormat, Integer, % SubStr((A_FI := A_FormatInteger) "H", 0)
    CRC32 := DllCall("NTDLL\RtlComputeCrc32", "UInt", 0, "UInt", &data, "UInt", length, "UInt")
    CRC := SubStr(CRC32 | 0x1000000000, -7)
    DllCall("User32.dll\CharLower", "Str", CRC)
    SetFormat, Integer, %A_FI%
    return CRC
}
