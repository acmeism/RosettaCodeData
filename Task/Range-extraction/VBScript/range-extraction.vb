Function Range_Extraction(list)
	num = Split(list,",")
	For i = 0 To UBound(num)
		startnum = CInt(num(i))
		sum = startnum
		Do While i <= UBound(num)
			If sum = CInt(num(i)) Then
				If i = UBound(num) Then
					If startnum <> CInt(num(i)) Then
						If startnum + 1 = CInt(num(i)) Then
							Range_Extraction = Range_Extraction & startnum & "," & num(i) & ","
						Else
							Range_Extraction = Range_Extraction & startnum & "-" & num(i) & ","
						End If
					Else
						Range_Extraction = Range_Extraction & startnum & ","
					End If
                                        Exit Do
				Else
					i = i + 1
					sum = sum + 1
				End If
			Else
				If startnum = CInt(num(i-1)) Then
					Range_Extraction = Range_Extraction & startnum & ","
				Else
					If startnum + 1 = CInt(num(i-1)) Then
						Range_Extraction = Range_Extraction & startnum & "," & num(i-1) & ","
					Else
						Range_Extraction = Range_Extraction & startnum & "-" & num(i-1) & ","
					End If
				End If
				i = i - 1
				Exit Do
			End If
		Loop
	Next
	Range_Extraction = Left(Range_Extraction,Len(Range_Extraction)-1)
End Function

WScript.StdOut.Write Range_Extraction("0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,37,38,39")
