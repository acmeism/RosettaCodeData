UriDecode(Uri) {
    LoopOffset := 0
    VarLength := 0
    VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0)
    Loop Parse, Uri
    {
        If (A_Index < LoopOffset) {
            Continue
        }
        If (A_LoopField = Chr(37)) {
            Number := "0x" . SubStr(Uri, A_Index + 1, 2)
            LoopOffset := A_Index + 3
        }
        Else {
            Number := Ord(A_LoopField)
        }
        NumPut(Number, Var, VarLength++, "UChar")
    }
    Return StrGet(&Var, VarLength, "UTF-8")
}
MsgBox % UriDecode("http%3A%2F%2Ffoo%20bar%2F")
MsgBox % UriDecode("google.com/search?q=%60Abdu%27l-Bah%C3%A1")
MsgBox % UriDecode("%25%32%35")
