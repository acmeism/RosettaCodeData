Sub AlignCols(Lines, Optional Align As AlignmentConstants, Optional Sep$ = "$", Optional Sp% = 1)
Dim i&, j&, D&, L&, R&: ReDim W(UBound(Lines)): ReDim C&(0)

  For j = 0 To UBound(W)
    W(j) = Split(Lines(j), Sep)
    If UBound(W(j)) > UBound(C) Then ReDim Preserve C(UBound(W(j)))
    For i = 0 To UBound(W(j)): If Len(W(j)(i)) > C(i) Then C(i) = Len(W(j)(i))
  Next i, j

  For j = 0 To UBound(W): For i = 0 To UBound(W(j))
    D = C(i) - Len(W(j)(i))
    L = Choose(Align + 1, 0, D, D \ 2)
    R = Choose(Align + 1, D, 0, D - L) + Sp
    Debug.Print Space(L); W(j)(i); Space(R); IIf(i < UBound(W(j)), "", vbLf);
  Next i, j
End Sub
