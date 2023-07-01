Imports System.Numerics

Public Class BigRat ' Big Rational Class constructed with BigIntegers
    Implements IComparable
    Public nu, de As BigInteger
    Public Shared Zero = New BigRat(BigInteger.Zero, BigInteger.One),
                  One = New BigRat(BigInteger.One, BigInteger.One)
    Sub New(bRat As BigRat)
        nu = bRat.nu : de = bRat.de
    End Sub
    Sub New(n As BigInteger, d As BigInteger)
        If d = BigInteger.Zero Then _
            Throw (New Exception(String.Format("tried to set a BigRat with ({0}/{1})", n, d)))
        Dim bi As BigInteger = BigInteger.GreatestCommonDivisor(n, d)
        If bi > BigInteger.One Then n /= bi : d /= bi
        If d < BigInteger.Zero Then n = -n : d = -d
        nu = n : de = d
    End Sub
    Shared Operator -(x As BigRat) As BigRat
        Return New BigRat(-x.nu, x.de)
    End Operator
    Shared Operator +(x As BigRat, y As BigRat)
        Return New BigRat(x.nu * y.de + x.de * y.nu, x.de * y.de)
    End Operator
    Shared Operator -(x As BigRat, y As BigRat) As BigRat
        Return x + (-y)
    End Operator
    Shared Operator *(x As BigRat, y As BigRat) As BigRat
        Return New BigRat(x.nu * y.nu, x.de * y.de)
    End Operator
    Shared Operator /(x As BigRat, y As BigRat) As BigRat
        Return New BigRat(x.nu * y.de, x.de * y.nu)
    End Operator
    Public Function CompareTo(obj As Object) As Integer Implements IComparable.CompareTo
        Dim dif As BigRat = New BigRat(nu, de) - obj
        If dif.nu < BigInteger.Zero Then Return -1
        If dif.nu > BigInteger.Zero Then Return 1
        Return 0
    End Function
    Shared Operator =(x As BigRat, y As BigRat) As Boolean
        Return x.CompareTo(y) = 0
    End Operator
    Shared Operator <>(x As BigRat, y As BigRat) As Boolean
        Return x.CompareTo(y) <> 0
    End Operator
    Overrides Function ToString() As String
        If de = BigInteger.One Then Return nu.ToString
        Return String.Format("({0}/{1})", nu, de)
    End Function
    Shared Function Combine(a As BigRat, b As BigRat) As BigRat
        Return (a + b) / (BigRat.One - (a * b))
    End Function
End Class

Public Structure Term ' coefficent, BigRational construction for each term
    Dim c As Integer, br As BigRat
    Sub New(cc As Integer, bigr As BigRat)
        c = cc : br = bigr
    End Sub
End Structure

Module Module1
    Function Eval(c As Integer, x As BigRat) As BigRat
        If c = 1 Then Return x Else If c < 0 Then Return Eval(-c, -x)
        Dim hc As Integer = c \ 2
        Return BigRat.Combine(Eval(hc, x), Eval(c - hc, x))
    End Function

    Function Sum(terms As List(Of Term)) As BigRat
        If terms.Count = 1 Then Return Eval(terms(0).c, terms(0).br)
        Dim htc As Integer = terms.Count / 2
        Return BigRat.Combine(Sum(terms.Take(htc).ToList), Sum(terms.Skip(htc).ToList))
    End Function

    Function ParseLine(ByVal s As String) As List(Of Term)
        ParseLine = New List(Of Term) : Dim t As String = s.ToLower, p As Integer, x As New Term(1, BigRat.Zero)
        While t.Contains(" ") : t = t.Replace(" ", "") : End While
        p = t.IndexOf("pi/4=") : If p < 0 Then _
            Console.WriteLine("warning: tan(left side of equation) <> 1") : ParseLine.Add(x) : Exit Function
        t = t.Substring(p + 5)
        For Each item As String In t.Split(")")
            If item.Length > 5 Then
                If (Not item.Contains("tan") OrElse item.IndexOf("a") < 0 OrElse
                    item.IndexOf("a") > item.IndexOf("tan")) AndAlso Not item.Contains("atn") Then
                    Console.WriteLine("warning: a term is mising a valid arctangent identifier on the right side of the equation: [{0})]", item)
                    ParseLine = New List(Of Term) : ParseLine.Add(New Term(1, BigRat.Zero)) : Exit Function
                End If
                x.c = 1 : x.br = New BigRat(BigRat.One)
                p = item.IndexOf("/") : If p > 0 Then
                    x.br.de = UInt64.Parse(item.Substring(p + 1))
                    item = item.Substring(0, p)
                    p = item.IndexOf("(") : If p > 0 Then
                        x.br.nu = UInt64.Parse(item.Substring(p + 1))
                        p = item.IndexOf("a") : If p > 0 Then
                            Integer.TryParse(item.Substring(0, p).Replace("*", ""), x.c)
                            If x.c = 0 Then x.c = 1
                            If item.Contains("-") AndAlso x.c > 0 Then x.c = -x.c
                        End If
                        ParseLine.Add(x)
                    End If
                End If
            End If
        Next
    End Function

    Sub Main(ByVal args As String())
        Dim nl As String = vbLf
        For Each item In ("pi/4 = ATan(1 / 2) + ATan(1/3)" & nl &
              "pi/4 = 2Atan(1/3) + ATan(1/7)" & nl &
              "pi/4 = 4ArcTan(1/5) - ATan(1 / 239)" & nl &
              "pi/4 = 5arctan(1/7) + 2 * atan(3/79)" & nl &
              "Pi/4 = 5ATan(29/278) + 7*ATan(3/79)" & nl &
              "pi/4 = atn(1/2) + ATan(1/5) + ATan(1/8)" & nl &
              "PI/4   = 4ATan(1/5) - Atan(1/70) + ATan(1/99)" & nl &
              "pi /4 = 5*ATan(1/7) + 4 ATan(1/53) + 2ATan(1/4443)" & nl &
              "pi / 4 = 6ATan(1/8) + 2arctangent(1/57) + ATan(1/239)" & nl &
              "pi/ 4 = 8ATan(1/10) - ATan(1/239) - 4ATan(1/515)" & nl &
              "pi/4 = 12ATan(1/18) + 8ATan(1/57) - 5ATan(1/239)" & nl &
              "pi/4 = 16 * ATan(1/21) + 3ATan(1/239) + 4ATan(3/1042)" & nl &
              "pi/4 = 22ATan(1/28) + 2ATan(1/443) - 5ATan(1/1393)  -    10  ATan( 1  /   11018 )" & nl &
              "pi/4 = 22ATan(1/38) + 17ATan(7/601) + 10ATan(7 /  8149)" & nl &
              "pi/4 = 44ATan(1/57) + 7ATan(1/239) - 12ATan(1/682) + 24ATan(1/12943)" & nl &
              "pi/4 = 88ATan(1/172) + 51ATan(1/239) + 32ATan(1/682) + 44ATan(1/5357) + 68ATan(1/12943)" & nl &
              "pi/4 = 88ATan(1/172) + 51ATan(1/239) + 32ATan(1/682) + 44ATan(1/5357) + 68ATan(1/12944)").Split(nl)
            Console.WriteLine("{0}: {1}", If(Sum(ParseLine(item)) = BigRat.One, "Pass", "Fail"), item)
        Next
    End Sub
End Module
