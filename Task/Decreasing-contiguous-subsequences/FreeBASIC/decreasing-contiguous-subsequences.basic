' Define the Sequence structure
Type Sequence
    startIndex As Integer
    endIndex As Integer
End Type

Dim As Integer datos(900) = { _
90, 90, 90, 91, 91, 92, 92, 92, 91, 91, 91, 90, 90, 90, 89, 89, 88, 87, 87, 87, _
86, 86, 86, 85, 85, 86, 86, 87, 87, 88, 89, 89, 89, 90, 90, 91, 91, 91, 92, 92, _
92, 92, 92, 92, 92, 92, 92, 91, 91, 90, 90, 90, 90, 90, 89, 89, 89, 89, 88, 88, _
88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 90, 90, 90, 89, _
89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 87, 88, 88, 88, 88, 88, 88, 88, 88, _
88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 88, 88, _
88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 88, 88, _
87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 88, _
88, 89, 89, 89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, _
89, 89, 89, 89, 89, 89, 89, 89, 89, 88, 88, 88, 87, 87, 87, 87, 86, 86, 86, 86, _
86, 86, 87, 87, 87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, _
89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, _
87, 87, 87, 87, 87, 87, 87, 89, 89, 91, 94, 94, 95, 96, 96, 96, 97, 97, 96, 96, _
96, 96, 95, 95, 94, 93, 93, 92, 92, 91, 91, 90, 89, 89, 88, 86, 86, 85, 83, 83, _
81, 80, 80, 80, 79, 79, 79, 78, 78, 79, 81, 82, 82, 85, 89, 89, 91, 93, 93, 94, _
95, 95, 95, 95, 95, 95, 95, 95, 95, 94, 94, 94, 94, 93, 93, 93, 92, 92, 91, 91, _
91, 90, 90, 90, 88, 87, 87, 86, 85, 85, 84, 84, 84, 83, 84, 84, 84, 85, 86, 86, _
87, 87, 87, 88, 88, 88, 89, 90, 90, 90, 91, 91, 92, 92, 92, 93, 94, 94, 94, 95, _
95, 95, 95, 94, 94, 94, 93, 93, 93, 92, 92, 92, 91, 91, 90, 89, 89, 87, 86, 85, _
85, 84, 83, 83, 82, 82, 82, 81, 81, 81, 81, 81, 81, 82, 85, 85, 86, 89, 89, 91, _
92, 93, 93, 93, 94, 94, 94, 94, 94, 94, 94, 94, 94, 93, 93, 93, 92, 92, 92, 91, _
91, 91, 90, 89, 89, 88, 88, 88, 87, 87, 87, 86, 86, 86, 85, 85, 85, 85, 85, 85, _
86, 87, 87, 87, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 90, 90, 90, 90, _
91, 91, 92, 93, 93, 94, 94, 95, 95, 95, 96, 96, 96, 95, 95, 95, 94, 94, 93, 93, _
93, 92, 90, 90, 89, 87, 87, 87, 85, 83, 83, 82, 81, 81, 81, 80, 80, 81, 81, 81, _
81, 81, 81, 81, 81, 81, 81, 81, 81, 83, 86, 88, 88, 90, 91, 91, 91, 92, 92, 93, _
93, 93, 94, 95, 95, 95, 96, 96, 96, 96, 96, 96, 96, 95, 95, 95, 95, 95, 94, 93, _
93, 92, 92, 92, 91, 90, 90, 90, 90, 90, 91, 93, 93, 94, 94, 94, 94, 95, 94, 94, _
94, 94, 94, 94, 93, 93, 93, 93, 93, 93, 92, 92, 92, 92, 92, 91, 91, 91, 91, 91, _
91, 91, 91, 90, 90, 90, 90, 90, 90, 90, 90, 89, 89, 89, 89, 89, 89, 89, 89, 89, _
89, 90, 90, 90, 90, 91, 91, 92, 93, 93, 93, 94, 94, 94, 94, 94, 94, 94, 94, 94, _
95, 95, 95, 95, 95, 95, 95, 95, 95, 94, 93, 93, 93, 93, 93, 92, 92, 92, 91, 91, _
91, 91, 90, 90, 90, 89, 89, 89, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, _
89, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 91, 91, 91, 91, 91, 91, 91, 91, 91, _
91, 91, 91, 91, 91, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 91, 92, _
92, 93, 93, 93, 93, 94, 94, 94, 93, 93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 91, _
90, 90, 90, 89, 88, 88, 87, 87, 87, 86, 86, 85, 85, 85, 86, 86, 86, 87, 87, 88, _
88, 88, 89, 90, 90, 90, 91, 91, 91, 91, 91, 91, 91, 91, 91, 92, 92, 92, 93, 93, _
93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 90, 90, 90, 89, 88, 87, 87, 87, 86, 86, _
86, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 87, 88, 88, 88, _
89, 89, 90, 91, 91, 92, 93, 93, 93, 94, 94, 94, 94, 94, 94, 94, 94, 94, 93, 93, _
93, 92, 92, 92, 91, 90, 90, 90, 89, 89, 88, 88, 88, 87, 87, 87, 87, 87, 87, 87, _
87, 87, 87, 87, 87, 87, 87, 88, 88, 88, 90, 90, 91, 93, 93, 93, 93, 93, 94, 93, _
93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 91, 90, 90, 90, 89, 89, 89, 88, 87, 87, _
87, 87, 87, 86, 87, 87, 87, 87, 87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, _
89 }
Dim ranges(4) As Integer = {4, 8, 12, 16, 25}
Dim counts(Lbound(ranges) To Ubound(ranges) + 1) As Integer

' Function to get the next non-ascending Sequence
Function nextSequence(datos() As Integer, prev As Sequence) As Sequence
    Dim As Integer sPos, ePos, value
    sPos = prev.endIndex + 1
    If sPos > Ubound(datos) Then
        Return Type<Sequence>(sPos, Ubound(datos))
    Else
        value = datos(sPos)
        ePos = sPos + 1
        While ePos <= Ubound(datos) Andalso datos(ePos) <= value
            value = datos(ePos)
            ePos += 1
        Wend
        Return Type<Sequence>(sPos, ePos - 1)
    End If
End Function

' Function to get the first non-ascending Sequence
Function firstSequence(datos() As Integer) As Sequence
    If Lbound(datos) > Ubound(datos) Then
        Return Type<Sequence>(Lbound(datos), Ubound(datos))
    Else
        Return nextSequence(datos(), Type<Sequence>(-1, Lbound(datos) - 1))
    End If
End Function

' Subroutine to count the non-ascending Sequence by percentage change
Sub countChangesByPercentage(datos() As Integer, ranges() As Integer, counts() As Integer)
    Dim prev As Sequence = firstSequence(datos())
    While prev.endIndex >= prev.startIndex
        If prev.endIndex > prev.startIndex Then
            Dim As Double change = ((datos(prev.startIndex) - datos(prev.endIndex)) / datos(prev.startIndex)) * 100
            If change > 0 Then
                For i As Integer = Lbound(counts) To Ubound(counts)
                    If ranges(i) > change Then
                        counts(i) += 1
                        Exit For
                    End If
                Next
                If change > ranges(Ubound(ranges)) Then counts(Ubound(counts)) += 1
            End If
        End If
        prev = nextSequence(datos(), prev)
    Wend
End Sub

' Procedure to show the range count
Sub showRangeCount(pStart As Integer, pEnd As Integer, cnt As Integer)
    Print Using "! ##_% .. ###_% ! : &"; (Iif(pStart = 0, "(", "[")); pStart; pEnd; Iif(pEnd = 100, "]", ")"); cnt
End Sub

' Main program
countChangesByPercentage(datos(), ranges(), counts())
Dim As Integer i, start
start = 0
For i = Lbound(counts) To Ubound(counts) - 1
    showRangeCount(start, ranges(i), counts(i))
    start = ranges(i)
Next
If start < 100 Then showRangeCount(start, 100, counts(Ubound(counts)))

Sleep
