Imports System.Numerics
Imports System.Text
Imports Freq = System.Collections.Generic.Dictionary(Of Char, Long)
Imports Triple = System.Tuple(Of System.Numerics.BigInteger, Integer, System.Collections.Generic.Dictionary(Of Char, Long))

Module Module1

    Function CumulativeFreq(freq As Freq) As Freq
        Dim total As Long = 0
        Dim cf As New Freq
        For i = 0 To 255
            Dim c = Chr(i)
            If freq.ContainsKey(c) Then
                Dim v = freq(c)
                cf(c) = total
                total += v
            End If
        Next
        Return cf
    End Function

    Function ArithmeticCoding(str As String, radix As Long) As Triple
        'The frequency of characters
        Dim freq As New Freq
        For Each c In str
            If freq.ContainsKey(c) Then
                freq(c) += 1
            Else
                freq(c) = 1
            End If
        Next

        'The cumulative frequency
        Dim cf = CumulativeFreq(freq)

        ' Base
        Dim base As BigInteger = str.Length

        ' Lower bound
        Dim lower As BigInteger = 0

        ' Product of all frequencies
        Dim pf As BigInteger = 1

        ' Each term is multiplied by the product of the
        ' frequencies of all previously occuring symbols
        For Each c In str
            Dim x = cf(c)
            lower = lower * base + x * pf
            pf = pf * freq(c)
        Next

        ' Upper bound
        Dim upper = lower + pf

        Dim powr = 0
        Dim bigRadix As BigInteger = radix

        While True
            pf = pf / bigRadix
            If pf = 0 Then
                Exit While
            End If
            powr = powr + 1
        End While

        Dim diff = (upper - 1) / (BigInteger.Pow(bigRadix, powr))
        Return New Triple(diff, powr, freq)
    End Function

    Function ArithmeticDecoding(num As BigInteger, radix As Long, pwr As Integer, freq As Freq) As String
        Dim powr As BigInteger = radix
        Dim enc = num * BigInteger.Pow(powr, pwr)
        Dim base = freq.Values.Sum()

        ' Create the cumulative frequency table
        Dim cf = CumulativeFreq(freq)

        ' Create the dictionary
        Dim dict As New Dictionary(Of Long, Char)
        For Each key In cf.Keys
            Dim value = cf(key)
            dict(value) = key
        Next

        ' Fill the gaps in the dictionary
        Dim lchar As Long = -1
        For i As Long = 0 To base - 1
            If dict.ContainsKey(i) Then
                lchar = AscW(dict(i))
            Else
                dict(i) = ChrW(lchar)
            End If
        Next

        ' Decode the input number
        Dim decoded As New StringBuilder
        Dim bigBase As BigInteger = base
        For i As Long = base - 1 To 0 Step -1
            Dim pow = BigInteger.Pow(bigBase, i)
            Dim div = enc / pow
            Dim c = dict(div)
            Dim fv = freq(c)
            Dim cv = cf(c)
            Dim diff = enc - pow * cv
            enc = diff / fv
            decoded.Append(c)
        Next

        ' Return the decoded ouput
        Return decoded.ToString()
    End Function

    Sub Main()
        Dim radix As Long = 10
        Dim strings = {"DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"}
        For Each St In strings
            Dim encoded = ArithmeticCoding(St, radix)
            Dim dec = ArithmeticDecoding(encoded.Item1, radix, encoded.Item2, encoded.Item3)
            Console.WriteLine("{0,-25}=> {1,19} * {2}^{3}", St, encoded.Item1, radix, encoded.Item2)
            If St <> dec Then
                Throw New Exception(vbTab + "However that is incorrect!")
            End If
        Next
    End Sub

End Module
