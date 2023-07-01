MsgBox, % UriEncode("http://foo bar/")

; Modified from http://goo.gl/0a0iJq
UriEncode(Uri, Reserved:="!#$&'()*+,/:;=?@[]") {
    Unreserved := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"
	VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0)
	StrPut(Uri, &Var, "UTF-8")
	While (Code := NumGet(Var, A_Index - 1, "UChar")) {
		If InStr(Unreserved . Reserved, Chr(Code)) {
			Encoded .= Chr(Code)
        }
		Else {
			Encoded .= Format("%{:02X}", Code)
        }
    }
	Return Encoded
}
