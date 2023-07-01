Option Explicit

Private Type MyTable
    powers_of_2 As Long
    doublings As Long
End Type

Private Type Assemble
    answer As Long
    accumulator As Long
End Type

Private Type Division
    Quotient As Long
    Remainder As Long
End Type

Private Type DivEgyp
    Dividend As Long
    Divisor As Long
End Type

Private Deg As DivEgyp

Sub Main()
Dim d As Division
    Deg.Dividend = 580
    Deg.Divisor = 34
    d = Divise(CreateTable)
    Debug.Print "Quotient = " & d.Quotient & " Remainder = " & d.Remainder
End Sub

Private Function CreateTable() As MyTable()
Dim t() As MyTable, i As Long
    Do
        i = i + 1
        ReDim Preserve t(i)
        t(i).powers_of_2 = 2 ^ (i - 1)
        t(i).doublings = Deg.Divisor * t(i).powers_of_2
    Loop While 2 * t(i).doublings <= Deg.Dividend
    CreateTable = t
End Function

Private Function Divise(t() As MyTable) As Division
Dim a As Assemble, i As Long
    a.accumulator = 0
    a.answer = 0
    For i = UBound(t) To LBound(t) Step -1
        If a.accumulator + t(i).doublings <= Deg.Dividend Then
            a.accumulator = a.accumulator + t(i).doublings
            a.answer = a.answer + t(i).powers_of_2
        End If
    Next
    Divise.Quotient = a.answer
    Divise.Remainder = Deg.Dividend - a.accumulator
End Function
