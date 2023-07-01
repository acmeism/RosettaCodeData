Imports System

Module Program
    Sub Main()
        Dim i, j, n, n1, n2, n3, n4, n5, n6, n7, n8, n9, s2, s3, s4, s5, s6, s7, s8 As Integer,
            sum, ten1 As Long, ten2 As Long = 10
        Dim pow(9) As Long, num() As Byte
        For i = 1 To 9 : pow(i) = i : For j = 2 To i : pow(i) *= i : Next : Next
        For n = 1 To 11 : For n9 = 0 To n : For n8 = 0 To n - n9 : s8 = n9 + n8 : For n7 = 0 To n - s8
                s7 = s8 + n7 : For n6 = 0 To n - s7 : s6 = s7 + n6 : For n5 = 0 To n - s6
                    s5 = s6 + n5 : For n4 = 0 To n - s5 : s4 = s5 + n4 : For n3 = 0 To n - s4
                        s3 = s4 + n3 : For n2 = 0 To n - s3 : s2 = s3 + n2 : For n1 = 0 To n - s2
                            sum = n1 * pow(1) + n2 * pow(2) + n3 * pow(3) + n4 * pow(4) +
                                  n5 * pow(5) + n6 * pow(6) + n7 * pow(7) + n8 * pow(8) + n9 * pow(9)
                            If sum < ten1 OrElse sum >= ten2 Then Continue For
                            redim num(9)
                            For Each ch As Char In sum.ToString() : num(Convert.ToByte(ch) - 48) += 1 : Next
                            If n - (s2 + n1) = num(0) AndAlso n1 = num(1) AndAlso n2 = num(2) AndAlso
                                n3 = num(3) AndAlso n4 = num(4) AndAlso n5 = num(5) AndAlso n6 = num(6) AndAlso
                                n7 = num(7) AndAlso n8 = num(8) AndAlso n9 = num(9) Then Console.WriteLine(sum)
                          Next : Next : Next : Next : Next : Next : Next : Next : Next
            ten1 = ten2 : ten2 *= 10
       Next
    End Sub
End Module
