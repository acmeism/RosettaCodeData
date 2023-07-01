Option Explicit

Declare Function GetTickCount Lib "kernel32.dll" () As Long
Declare Sub ZeroMemory Lib "kernel32.dll" Alias "RtlZeroMemory" (ByRef Destination As Any, ByVal Length As Long)


Sub Main()
Dim i As Long, j As Long, n As Long, t As Long
Dim sum As Double
Dim n0 As Double
Dim n1 As Double
Dim n2 As Double
Dim n3 As Double
Dim n4 As Double
Dim n5 As Double
Dim n6 As Double
Dim n7 As Double
Dim n8 As Double
Dim n9 As Double
Dim ten1 As Double
Dim ten2 As Double
Dim s1 As Long
Dim s2 As Long
Dim s3 As Long
Dim s4 As Long
Dim s5 As Long
Dim s6 As Long
Dim s7 As Long
Dim s8 As Long
Dim pow(9) As Long, num(9) As Long
Dim number As String, res As String

  t = GetTickCount()
  ten2 = 10
  For i = 1 To 9
    pow(i) = i
    For j = 2 To i
      pow(i) = i * pow(i)
    Next j
  Next i
  For n = 1 To 11
    For n9 = 0 To n
      For n8 = 0 To n - n9
        s8 = n9 + n8
        For n7 = 0 To n - s8
          s7 = s8 + n7
          For n6 = 0 To n - s7
            s6 = s7 + n6
            For n5 = 0 To n - s6
              s5 = s6 + n5
              For n4 = 0 To n - s5
                s4 = s5 + n4
                For n3 = 0 To n - s4
                  s3 = s4 + n3
                  For n2 = 0 To n - s3
                    s2 = s3 + n2
                    For n1 = 0 To n - s2
                      n0 = n - (s2 + n1)
                      sum = n1 * pow(1) + n2 * pow(2) + n3 * pow(3) + _
                            n4 * pow(4) + n5 * pow(5) + n6 * pow(6) + _
                            n7 * pow(7) + n8 * pow(8) + n9 * pow(9)
                      Select Case sum
                      Case ten1 To ten2 - 1
                        number = CStr(sum)
                        ZeroMemory num(0), 40
                        For i = 1 To n
                          j = Asc(Mid$(number, i, 1)) - 48
                          num(j) = num(j) + 1
                        Next i
                        If n0 = num(0) Then
                          If n1 = num(1) Then
                            If n2 = num(2) Then
                              If n3 = num(3) Then
                                If n4 = num(4) Then
                                  If n5 = num(5) Then
                                    If n6 = num(6) Then
                                      If n7 = num(7) Then
                                        If n8 = num(8) Then
                                          If n9 = num(9) Then
                                            res = res & CStr(sum) & vbNewLine
                                          End If
                                        End If
                                      End If
                                    End If
                                  End If
                                End If
                              End If
                            End If
                          End If
                        End If
                      End Select
                    Next n1
                  Next n2
                Next n3
              Next n4
            Next n5
          Next n6
        Next n7
      Next n8
    Next n9
    ten1 = ten2
    ten2 = ten2 * 10
  Next n
  t = GetTickCount() - t
  res = res & "execution time:" & Str$(t) & " ms"
  MsgBox res
End Sub
