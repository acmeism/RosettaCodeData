Sub M_snb()
  c00 = "_abe abi eve cath ivy jan dee fay bea hope gay " & _
        "_bob cath hope abi dee eve fay bea jan ivy gay " & _
        "_col hope eve abi dee bea fay ivy gay cath jan " & _
        "_dan ivy fay dee gay hope eve jan bea cath abi " & _
        "_ed jan dee bea cath fay eve abi ivy hope gay " & _
        "_fred bea abi dee gay eve ivy cath jan hope fay " & _
        "_gav gay eve ivy bea cath abi dee hope jan fay " & _
        "_hal abi eve hope fay ivy cath jan bea gay dee " & _
        "_ian hope cath dee gay bea abi fay ivy jan eve " & _
        "_jon abi fay jan gay eve bea dee cath ivy hope " & _
        "_abi bob fred jon gav ian abe dan ed col hal " & _
        "_bea bob abe col fred gav dan ian ed jon hal " & _
        "_cath fred bob ed gav hal col ian abe dan jon " & _
        "_dee fred jon col abe ian hal gav dan bob ed " & _
        "_eve jon hal fred dan abe gav col ed ian bob " & _
        "_fay bob abe ed ian jon dan fred gav col hal " & _
        "_gay jon gav hal fred bob abe col ed dan ian " & _
        "_hope gav jon bob abe ian dan hal ed col fred " & _
        "_ivy ian col hal gav fred bob abe ed jon dan " & _
        "_jan ed hal gav abe bob jon col ian fred dan "

  sn = Filter(Filter(Split(c00), "_"), "-", 0)
  Do
    c01 = Mid(c00, InStr(c00, sn(0) & " "))
    st = Split(Left(c01, InStr(Mid(c01, 2), "_")))
      For j = 1 To UBound(st) - 1
        If InStr(c00, "_" & st(j) & " ") > 0 Then
          c00 = Replace(Replace(c00, sn(0), sn(0) & "-" & st(j)), "_" & st(j), "_" & st(j) & "." & Mid(sn(0), 2))
          Exit For
        Else
          c02 = Filter(Split(c00, "_"), st(j) & ".")(0)
          c03 = Split(Split(c02)(0), ".")(1)
          If InStr(c02, " " & Mid(sn(0), 2) & " ") < InStr(c02, " " & c03 & " ") Then
            c00 = Replace(Replace(Replace(c00, c03 & "-" & st(j), c03), sn(0), sn(0) & "-" & st(j)), "_" & st(j), "_" & st(j) & "." & Mid(sn(0), 2))
            Exit For
          End If
        End If
     Next
     sn = Filter(Filter(Filter(Split(c00), "_"), "-", 0), ".", 0)
   Loop Until UBound(sn) = -1

   MsgBox Replace(Join(Filter(Split(c00), "-"), vbLf), "_", "")
End Sub
