Imports System

Module Module1
    ' flags:
    Const _
        PrMk As Integer = 0,  ' a number that is prime
        SqMk As Integer = 1,  ' a number that is the square of a prime number
        UpMk As Integer = 2,  ' a number that can be factored (aka un-prime)
        BrMk As Integer = -2, ' a prime number that is also a Brazilian number
        Excp As Integer = 121 ' exception square - the only square prime that is a Brazilian

    Dim pow As Integer = 9,
        max As Integer '  maximum sieve array length
    '     An upper limit of the required array length can be calculated Like this:
    ' power of 10  fraction              limit        actual result
    '   1          2 / 1 * 10          = 20           20
    '   2          4 / 3 * 100         = 133          132
    '   3          6 / 5 * 1000        = 1200         1191
    '   4          8 / 7 * 10000       = 11428        11364
    '   5          10/ 9 * 100000      = 111111       110468
    '   6          12/11 * 1000000     = 1090909      1084566
    '   7          14/13 * 10000000    = 10769230     10708453
    '   8          16/15 * 100000000   = 106666666    106091516
    '   9          18/17 * 1000000000  = 1058823529   1053421821
    ' powers above 9 are impractical because of the maximum array length in VB.NET,
    ' which is around the UInt32.MaxValue, Or 4294967295

    Dim PS As SByte() ' the prime/Brazilian number sieve
    ' once the sieve is populated, primes are <= 0, non-primes are > 0,
    ' Brazilian numbers are (< 0) or (> 1)
    ' 121 is a special case, in the sieve it is marked with the BrMk (-2)

    ' typical sieve of Eratosthenes algorithm
    Sub PrimeSieve(ByVal top As Integer)
        PS = New SByte(top) {} : Dim i, ii, j As Integer
        i = 2 : j = 4 : PS(j) = SqMk : While j < top - 2 : j += 2 : PS(j) = UpMk : End While
        i = 3 : j = 9 : PS(j) = SqMk : While j < top - 6 : j += 6 : PS(j) = UpMk : End While
        i = 5 : ii = 25 : While ii < top
            If PS(i) = PrMk Then
                j = (top - i) / i : If (j And 1) = 0 Then j -= 1
                Do : If PS(j) = PrMk Then PS(i * j) = UpMk
                    j -= 2 : Loop While j > i : PS(ii) = SqMk
            End If
            Do : i += 2 : Loop While PS(i) <> PrMk : ii = i * i
        End While
    End Sub

    ' consults the sieve and returns whether a number is Brazilian
    Function IsBr(ByVal number As Integer) As Boolean
        Return Math.Abs(PS(number)) > SqMk
    End Function

    ' shows the first few Brazilian numbers of several kinds
    Sub FirstFew(ByVal kind As String, ByVal amt As Integer)
        Console.WriteLine(vbLf & "The first {0} {1}Brazilian Numbers are:", amt, kind)
        Dim i As Integer = 7 : While amt > 0
            If IsBr(i) Then amt -= 1 : Console.Write("{0} ", i)
            Select Case kind : Case "odd " : i += 2
                Case "prime " : Do : i += 2 : Loop While PS(i) <> BrMk OrElse i = Excp
                Case Else : i += 1 : End Select : End While : Console.WriteLine()
    End Sub

    ' expands a 111_X number into an integer
    Function Expand(ByVal NumberOfOnes As Integer, ByVal Base As Integer) As Integer
        Dim res As Integer = 1
        While NumberOfOnes > 1 AndAlso res < Integer.MaxValue \ Base
            res = res * Base + 1 : NumberOfOnes -= 1 : End While
        If res > max OrElse res < 0 Then res = 0
        Return res
    End Function

    ' returns an elapsed time string
    Function TS(ByVal fmt As String, ByRef st As DateTime, ByVal Optional reset As Boolean = False) As String
        Dim n As DateTime = DateTime.Now,
            res As String = String.Format(fmt, (n - st).TotalMilliseconds)
        If reset Then st = n
        Return res
    End Function

    Sub Main(args As String())
        Dim p2 As Integer = pow << 1, primes(6) As Integer, n As Integer,
            st As DateTime = DateTime.Now, st0 As DateTime = st,
            p10 As Integer = CInt(Math.Pow(10, pow)), p As Integer = 10, cnt As Integer = 0
        max = CInt(((CLng((p10)) * p2) / (p2 - 1))) : PrimeSieve(max)
        Console.WriteLine(TS("Sieving took {0} ms", st, True))
        ' make short list of primes before Brazilians are added
        n = 3 : For i As Integer = 0 To primes.Length - 1
            primes(i) = n : Do : n += 2 : Loop While PS(n) <> 0 : Next
        Console.WriteLine(vbLf & "Checking first few prime numbers of sequential ones:" &
                          vbLf & "ones checked found")
        ' now check the '111_X' style numbers. many are factorable, but some are prime,
        ' then re-mark the primes found in the sieve as Brazilian.
        ' curiously, only the numbers with a prime number of ones will turn out, so
        ' restricting the search to those saves time. no need to wast time on even numbers of ones,
        ' or 9 ones, 15 ones, etc...
        For Each i As Integer In primes
            Console.Write("{0,4}", i) : cnt = 0 : n = 2 : Do
                If (n - 1) Mod i <> 0 Then
                    Dim br As Long = Expand(i, n)
                    If br > 0 Then
                        If PS(br) < UpMk Then PS(br) = BrMk : cnt += 1
                    Else
                        Console.WriteLine("{0,8}{1,6}", n, cnt) : Exit Do
                    End If
                End If : n += 1 : Loop While True
        Next
        Console.WriteLine(TS("Adding Brazilian primes to the sieve took {0} ms", st, True))
        For Each s As String In ",odd ,prime ".Split(",") : FirstFew(s, 20) : Next
        Console.WriteLine(TS(vbLf & "Required output took {0} ms", st, True))
        Console.WriteLine(vbLf & "Decade count of Brazilian numbers:")
        n = 6 : cnt = 0 : Do : While cnt < p : n += 1 : If IsBr(n) Then cnt += 1
            End While
            Console.WriteLine("{0,15:n0}th is {1,-15:n0}  {2}", cnt, n, TS("time: {0} ms", st))
            If p < p10 Then p *= 10 Else Exit Do
        Loop While (True) : PS = New SByte(-1) {}
        Console.WriteLine(vbLf & "Total elapsed was {0} ms", (DateTime.Now - st0).TotalMilliseconds)
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub

End Module
