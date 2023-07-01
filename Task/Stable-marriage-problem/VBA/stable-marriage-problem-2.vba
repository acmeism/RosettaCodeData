Sub M_snb()
  Set d_00 = CreateObject("scripting.dictionary")
  Set d_01 = CreateObject("scripting.dictionary")
  Set d_02 = CreateObject("scripting.dictionary")

  sn = Split("abe abi eve cath ivy jan dee fay bea hope gay _" & _
       "bob cath hope abi dee eve fay bea jan ivy gay _" & _
       "col hope eve abi dee bea fay ivy gay cath jan _" & _
       "dan ivy fay dee gay hope eve jan bea cath abi _" & _
       "ed jan dee bea cath fay eve abi ivy hope gay _" & _
       "fred bea abi dee gay eve ivy cath jan hope fay _" & _
       "gav gay eve ivy bea cath abi dee hope jan fay _" & _
       "hal abi eve hope fay ivy cath jan bea gay dee _" & _
       "ian hope cath dee gay bea abi fay ivy jan eve _" & _
       "jon abi fay jan gay eve bea dee cath ivy hope ", "_")

  sp = Split("abi bob fred jon gav ian abe dan ed col hal _" & _
       "bea bob abe col fred gav dan ian ed jon hal _" & _
       "cath fred bob ed gav hal col ian abe dan jon _" & _
       "dee fred jon col abe ian hal gav dan bob ed _" & _
       "eve jon hal fred dan abe gav col ed ian bob _" & _
       "fay bob abe ed ian jon dan fred gav col hal _" & _
       "gay jon gav hal fred bob abe col ed dan ian _" & _
       "hope gav jon bob abe ian dan hal ed col fred _" & _
       "ivy ian col hal gav fred bob abe ed jon dan _" & _
       "jan ed hal gav abe bob jon col ian fred dan ", "_")

  For j = 0 To UBound(sn)
    d_00(Split(sn(j))(0)) = ""
    d_01(Split(sp(j))(0)) = ""
    d_02(Split(sn(j))(0)) = sn(j)
    d_02(Split(sp(j))(0)) = sp(j)
  Next

  Do
    For Each it In d_00.keys
      If d_00.Item(it) = "" Then
        st = Split(d_02.Item(it))
        For jj = 1 To UBound(st)
          If d_01(st(jj)) = "" Then
            d_00(st(0)) = st(0) & vbTab & st(jj)
            d_01(st(jj)) = st(0)
            Exit For
          ElseIf InStr(d_02.Item(st(jj)), " " & st(0) & " ") < InStr(d_02.Item(st(jj)), " " & d_01(st(jj)) & " ") Then
            d_00(d_01(st(jj))) = ""
            d_00(st(0)) = st(0) & vbTab & st(jj)
            d_01(st(jj)) = st(0)
            Exit For
          End If
        Next
      End If
    Next
  Loop Until UBound(Filter(d_00.items, vbTab)) = d_00.Count - 1

  MsgBox Join(d_00.items, vbLf)
End Sub
