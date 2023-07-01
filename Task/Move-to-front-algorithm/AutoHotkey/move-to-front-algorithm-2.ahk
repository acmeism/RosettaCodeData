testStrings = broood,bananaaa,hiphophiphop
loop, parse, testStrings, `,
	Output .= A_LoopField "`t" MTF_Encode(A_LoopField) "`t" MTF_Decode(MTF_Encode(A_LoopField)) "`n"
MsgBox  % Output
return
