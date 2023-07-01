Option Strict On
Option Explicit On

Imports System.IO

''' <summary>
''' Finds n digit numbers N such that the sum of the nth powers of
''' their digits = N
''' </summary>
Module OwnDigitsPowerSum

    Public Sub Main

        ' counts of used digits, check is a copy used to check the number is an own digit power sum
        Dim used(9) As Integer
        Dim check(9) As Integer
        Dim power(9, 9) As Long
        For i As Integer = 0 To 9
            check(i) = 0
        Next i
        For i As Integer = 1 To 9
            power(1,  i) = i
        Next i
        For j As Integer =  2 To 9
            For i As Integer = 1 To 9
                power(j, i) = power(j - 1, i) * i
            Next i
        Next j
        ' find the lowest possible first digit for each digit combination
        ' this is the roughly the low3est n where P*n^p > 10^p
        Dim lowestDigit(9) As Integer
        lowestDigit(1) = -1
        lowestDigit(2) = -1
        Dim p10 As Long = 100
        For i As Integer = 3 To 9
            For p As Integer = 2 To 9
                Dim np As Long = power(i, p) * i
                If Not ( np < p10) Then Exit For
                lowestDigit(i) = p
            Next p
            p10 *= 10
        Next i
        ' find the maximum number of zeros possible for each width and max digit
        Dim maxZeros(9, 9) As Integer
        For i As Integer = 1 To 9
            For j As Integer = 1 To 9
                maxZeros(i, j) = 0
            Next j
        Next i
        p10 = 1000
        For w As Integer = 3 To 9
            For d As Integer = lowestDigit(w) To 9
                Dim nz As Integer = 9
                Do
                    If nz < 0 Then
                        Exit Do
                    Else
                        Dim np As Long = power(w, d) * nz
                        IF Not ( np > p10) Then Exit Do
                    End If
                    nz -= 1
                Loop
                maxZeros(w, d) = If(nz > w, 0, w - nz)
            Next d
            p10 *= 10
        Next w
        ' find the numbers, works backeards through the possible combinations of
        ' digits, starting from all 9s
        Dim numbers(100) As Long     ' will hold the own digit power sum numbers
        Dim nCount As Integer = 0    ' count of the own digit power sums
        Dim tryCount As Integer = 0  ' count of digit combinations tried
        Dim digits(9) As Integer     ' the latest digit combination to try
        For d As Integer = 1 To 9
             digits(d) = 9
        Next d
        For d As Integer = 0 To 8
            used(d) = 0
        Next d
        used(9) = 9
        Dim width As Integer = 9     ' number of digits
        Dim last As Integer = width  ' final digit position
        p10 = 100000000              ' min value for a width digit power sum
        Do While width > 2
            tryCount += 1
            Dim dps As Long = 0      ' construct the digit power sum
            check(0) = used(0)
            For i As Integer = 1 To 9
                check(i) = used(i)
                If used(i) <> 0 Then
                    dps += used(i) * power(width, i)
                End If
            Next i
            ' reduce the count of each digit by the number of times it appear in the digit power sum
            Dim n As Long = dps
            Do
                check(CInt(n Mod 10)) -= 1 ' reduce the count of this digit
                n \= 10
            Loop Until n <= 0
            Dim reduceWidth As Boolean = dps <= p10
            If Not reduceWidth Then
                ' dps is not less than the minimum possible width number
                ' check there are no non-zero check counts left and so result is
                ' equal to its digit power sum
                Dim zCount As Integer = 0
                For i As Integer = 0 To 9
                    If check(i) <> 0 Then Exit For
                    zCount+= 1
                Next i
                If zCount = 10 Then
                    nCount += 1
                    numbers(nCount) = dps
                End If
                ' prepare the next digit combination: reduce the last digit
                used(digits(last)) -= 1
                digits(last) -= 1
                If digits(last) = 0 Then
                    ' the last digit is now zero - check this number of zeros is possible
                    If used(0) >= maxZeros(width, digits(1)) Then
                        ' have exceeded the maximum number of zeros for the first digit in this width
                        digits(last) = -1
                    End If
                End If
                If digits(last) >= 0 Then
                    ' still processing the last digit
                    used(digits(last)) += 1
                Else
                    ' last digit is now -1, start processing the previous digit
                    Dim prev As Integer = last
                    Do
                        prev -= 1
                        If prev < 1 Then
                            Exit Do
                        Else
                            used(digits(prev)) -= 1
                            digits(prev) -= 1
                            IF digits(prev) >= 0 Then Exit Do
                        End If
                    Loop
                    If prev > 0 Then
                        ' still some digits to process
                        If prev = 1 Then
                            If digits(1) <= lowestDigit(width) Then
                               ' just finished the lowest possible maximum digit for this width
                               prev = 0
                            End If
                        End If
                        If prev <> 0 Then
                           ' OK to try a lower digit
                            used(digits(prev)) += 1
                            For i As Integer = prev + 1 To width
                                digits(i) = digits(prev)
                                used(digits(prev)) += 1
                            Next i
                        End If
                    End If
                    If prev <= 0 Then
                        ' processed all the digits for this width
                        reduceWidth = True
                    End If
                End If
            End If
            If reduceWidth Then
                ' reduce the number of digits
                last -= 1
                width = last
                If last > 0 Then
                    ' iniialise for fewer digits
                    For d As Integer = 1 To last
                        digits(d) = 9
                    Next d
                    For d As Integer = last + 1 To 9
                        digits(d) = -1
                    Next d
                    For d As Integer = 0 To 8
                        used(d) = 0
                    Next d
                    used(9) = last
                    p10 \= 10
                End If
            End If
        Loop
        ' show the own digit power sums
        Console.Out.WriteLine("Own digits power sums for N = 3 to 9 inclusive:")
        For i As Integer = nCount To 1 Step -1
            Console.Out.WriteLine(numbers(i))
        Next i
        Console.Out.WriteLine("Considered " & tryCount & " digit combinations")

    End Sub


End Module
