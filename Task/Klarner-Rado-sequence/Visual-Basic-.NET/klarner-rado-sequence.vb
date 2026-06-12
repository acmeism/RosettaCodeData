Option Strict On
Option Explicit On

Imports System.IO

Module KlarnerRado

    Private Const bitsWidth As Integer = 31

    Private bitMask() As Integer = _
        New Integer(){ 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024 _
                     , 2048, 4096, 8192, 16384, 32768, 65536, 131072 _
                     , 262144, 524288, 1048576, 2097152, 4194304, 8388608 _
                     , 16777216, 33554432, 67108864, 134217728, 268435456 _
                     , 536870912, 1073741824 _
                     }

    Private Const maxElement As Integer = 1100000000


    Private Function BitSet(bit As Integer, v As Integer) As Boolean
        Return (v And bitMask(bit - 1)) <> 0
    End Function

    Private Function SetBit(ByVal bit As Integer, ByVal b As Integer) As Integer
        Return b Or bitMask(bit - 1)
    End Function

    Public Sub Main
        Dim  kr(maxElement \ bitsWidth) As Integer

        For i As Integer = 0 To kr.Count() - 1
            kr(i) = 0
        Next  i

        Dim krCount As Integer =  0    ' count of sequende elements
        Dim n21 As Integer = 3         ' next 2n+1 value
        Dim n31 As Integer = 4         ' next 3n+1 value
        Dim p10 As Integer = 1000      ' next power of ten to show the count/element at
        Dim iBit As Integer = 0        ' i Mod bitsWidth  - used to set the ith bit
        Dim iOverBw As Integer = 0     ' i \ bitsWidth    - used to set the ith bit
        '   p2                         ' the n for the 2n+1 value
        Dim p2Bit As Integer = 1       ' p2 Mod bitsWidth  - used to set the p2th bit
        Dim p2OverBw As Integer = 0    ' p2 \ bitsWidth    - used to set the p2th bit
        '   p3                         ' the n for the 3n+1 value
        Dim p3Bit As Integer = 1       ' p3 Mod bitsWidth  - used to set the p3th bit
        Dim p3OverBw As Integer = 0    ' p3 \ bitsWidth    - used to set the p3th bit

        kr(0) = SetBit(1, kr(0))
        Dim kri As Boolean = True
        Dim lastI As Integer = 0
        For i As Integer = 1 To  maxElement
            iBit += 1
            If iBit > bitsWidth Then
                iBit = 1
                iOverBw += 1
            End If
            If i = n21 Then            ' found the next 2n+1 value
                If BitSet(p2Bit, kr(p2OverBw)) Then
                    kri = True
                End If
                p2Bit += 1
                If p2Bit > bitsWidth Then
                    p2Bit = 1
                    p2OverBw += 1
                End If
                n21 += 2
            End If
            If i = n31 Then            ' found the next 3n+1 value
                If BitSet(p3Bit, kr(p3OverBw)) Then
                    kri = True
                End If
                p3Bit += 1
                If p3Bit > bitsWidth Then
                    p3Bit = 1
                    p3OverBw += 1
                End If
                n31 += 3
            End If
            If kri Then
                lastI = i
                kr(iOverBw) = SetBit(iBit, kr(iOverBw))
                krCount += 1
                If krCount <= 100 Then
                    Console.Out.Write(" " & i.ToString().PadLeft(3))
                    If krCount Mod 20 = 0 Then
                        Console.Out.WriteLine()
                    End If
                ElseIf krCount = p10 Then
                    Console.Out.WriteLine("Element " & p10.ToString().PadLeft(10) & " is " & i.ToString().PadLeft(10))
                    p10 *= 10
                End If
                kri = False
            End If
        Next  i
        Console.Out.WriteLine("Element " & krCount.ToString().PadLeft(10) & " is " & lastI.ToString().PadLeft(10))

    End Sub

End Module
