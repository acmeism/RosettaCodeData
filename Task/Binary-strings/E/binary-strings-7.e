? for i => byte ? (byte == 2) in bstr2 { bstr2[i] := -1 }
? bstr2
# value: [-127, -1, 3].diverge()
