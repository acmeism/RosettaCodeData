data =
(comment
0x0041
0x00F6
0x0416
0x20AC
0x1D11E
)

output := "unicode`t`tUTF`t`tunicode`n"
for i, Hex in StrSplit(data, "`n", "`r"){
	UTFCode := Encode_UTF(Hex)
	output .= Hex "`t`t" UTFCode "`t`t" Decode_UTF(UTFCode) "`n"
}
MsgBox % output
return
