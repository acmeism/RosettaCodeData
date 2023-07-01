Sub arrShellSort(ByVal arrData As Variant)
  Dim lngHold, lngGap As Long
  Dim lngCount, lngMin, lngMax As Long
  Dim varItem As Variant
  '
  lngMin = LBound(arrData)
  lngMax = UBound(arrData)
  lngGap = lngMin
  Do While (lngGap < lngMax)
    lngGap = 3 * lngGap + 1
  Loop
  Do While (lngGap > 1)
    lngGap = lngGap \ 3
    For lngCount = lngGap + lngMin To lngMax
      varItem = arrData(lngCount)
      lngHold = lngCount
      Do While ((arrData(lngHold - lngGap) > varItem))
        arrData(lngHold) = arrData(lngHold - lngGap)
        lngHold = lngHold - lngGap
        If (lngHold < lngMin + lngGap) Then Exit Do
      Loop
      arrData(lngHold) = varItem
    Next
  Loop
  arrShellSort = arrData
End Sub'
