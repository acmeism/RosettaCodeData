Imports System.Text

Module Module1
    Private ReadOnly MAX_ALL_FACTORS As Integer = 100_000
#Const ALGORITHM = 2

    Class Term
        Implements IComparable(Of Term)

        Public ReadOnly Property Coefficient As Long
        Public ReadOnly Property Exponent As Long

        Public Sub New(c As Long, Optional e As Long = 0)
            Coefficient = c
            Exponent = e
        End Sub

        Public Shared Operator -(t As Term) As Term
            Return New Term(-t.Coefficient, t.Exponent)
        End Operator

        Public Shared Operator +(lhs As Term, rhs As Term) As Term
            If lhs.Exponent <> rhs.Exponent Then
                Throw New ArgumentException("Exponents not equal")
            End If
            Return New Term(lhs.Coefficient + rhs.Coefficient, lhs.Exponent)
        End Operator

        Public Shared Operator *(lhs As Term, rhs As Term) As Term
            Return New Term(lhs.Coefficient * rhs.Coefficient, lhs.Exponent + rhs.Exponent)
        End Operator

        Public Function CompareTo(other As Term) As Integer Implements IComparable(Of Term).CompareTo
            Return -Exponent.CompareTo(other.Exponent)
        End Function

        Public Overrides Function ToString() As String
            If Coefficient = 0 Then
                Return "0"
            End If
            If Exponent = 0 Then
                Return Coefficient.ToString
            End If
            If Coefficient = 1 Then
                If Exponent = 1 Then
                    Return "x"
                End If
                Return String.Format("x^{0}", Exponent)
            End If
            If Coefficient = -1 Then
                If Exponent = 1 Then
                    Return "-x"
                End If
                Return String.Format("-x^{0}", Exponent)
            End If
            If Exponent = 1 Then
                Return String.Format("{0}x", Coefficient)
            End If
            Return String.Format("{0}x^{1}", Coefficient, Exponent)
        End Function
    End Class

    Class Polynomial
        Implements IEnumerable(Of Term)

        Private ReadOnly polyTerms As New List(Of Term)

        Public Sub New()
            polyTerms.Add(New Term(0))
        End Sub

        Public Sub New(ParamArray values() As Term)
            If values.Length = 0 Then
                polyTerms.Add(New Term(0))
            Else
                polyTerms.AddRange(values)
            End If
            Normalize()
        End Sub

        Public Sub New(values As IEnumerable(Of Term))
            polyTerms.AddRange(values)
            If polyTerms.Count = 0 Then
                polyTerms.Add(New Term(0))
            End If
            Normalize()
        End Sub

        Public Function LeadingCoeficient() As Long
            Return polyTerms(0).Coefficient
        End Function

        Public Function Degree() As Long
            Return polyTerms(0).Exponent
        End Function

        Public Function HasCoefficentAbs(coeff As Long) As Boolean
            For Each t In polyTerms
                If Math.Abs(t.Coefficient) = coeff Then
                    Return True
                End If
            Next
            Return False
        End Function

        Public Function GetEnumerator() As IEnumerator(Of Term) Implements IEnumerable(Of Term).GetEnumerator
            Return polyTerms.GetEnumerator
        End Function

        Private Function IEnumerable_GetEnumerator() As IEnumerator Implements IEnumerable.GetEnumerator
            Return polyTerms.GetEnumerator
        End Function

        Private Sub Normalize()
            polyTerms.Sort(Function(a As Term, b As Term) a.CompareTo(b))
        End Sub

        Public Shared Operator +(lhs As Polynomial, rhs As Term) As Polynomial
            Dim terms As New List(Of Term)
            Dim added = False
            For Each ct In lhs
                If ct.Exponent = rhs.Exponent Then
                    added = True
                    If ct.Coefficient + rhs.Coefficient <> 0 Then
                        terms.Add(ct + rhs)
                    End If
                Else
                    terms.Add(ct)
                End If
            Next
            If Not added Then
                terms.Add(rhs)
            End If
            Return New Polynomial(terms)
        End Operator

        Public Shared Operator *(lhs As Polynomial, rhs As Term) As Polynomial
            Dim terms As New List(Of Term)
            For Each ct In lhs
                terms.Add(ct * rhs)
            Next
            Return New Polynomial(terms)
        End Operator

        Public Shared Operator +(lhs As Polynomial, rhs As Polynomial) As Polynomial
            Dim terms As New List(Of Term)
            Dim thisCount = lhs.polyTerms.Count
            Dim polyCount = rhs.polyTerms.Count
            While thisCount > 0 OrElse polyCount > 0
                If thisCount = 0 Then
                    Dim polyTerm = rhs.polyTerms(polyCount - 1)
                    terms.Add(polyTerm)
                    polyCount -= 1
                ElseIf polyCount = 0 Then
                    Dim thisTerm = lhs.polyTerms(thisCount - 1)
                    terms.Add(thisTerm)
                    thisCount -= 1
                Else
                    Dim polyTerm = rhs.polyTerms(polyCount - 1)
                    Dim thisTerm = lhs.polyTerms(thisCount - 1)
                    If thisTerm.Exponent = polyTerm.Exponent Then
                        Dim t = thisTerm + polyTerm
                        If t.Coefficient <> 0 Then
                            terms.Add(t)
                        End If
                        thisCount -= 1
                        polyCount -= 1
                    ElseIf thisTerm.Exponent < polyTerm.Exponent Then
                        terms.Add(thisTerm)
                        thisCount -= 1
                    Else
                        terms.Add(polyTerm)
                        polyCount -= 1
                    End If
                End If
            End While
            Return New Polynomial(terms)
        End Operator

        Public Shared Operator *(lhs As Polynomial, rhs As Polynomial) As Polynomial
            Throw New Exception("Not implemented")
        End Operator

        Public Shared Operator /(lhs As Polynomial, rhs As Polynomial) As Polynomial
            Dim q As New Polynomial
            Dim r = lhs
            Dim lcv = rhs.LeadingCoeficient
            Dim dv = rhs.Degree
            While r.Degree >= rhs.Degree
                Dim lcr = r.LeadingCoeficient
                Dim s = lcr \ lcv
                Dim t As New Term(s, r.Degree() - dv)
                q += t
                r += rhs * -t
            End While
            Return q
        End Operator

        Public Overrides Function ToString() As String
            Dim builder As New StringBuilder
            Dim it = polyTerms.GetEnumerator()
            If it.MoveNext Then
                builder.Append(it.Current)
            End If
            While it.MoveNext
                If it.Current.Coefficient < 0 Then
                    builder.Append(" - ")
                    builder.Append(-it.Current)
                Else
                    builder.Append(" + ")
                    builder.Append(it.Current)
                End If
            End While
            Return builder.ToString
        End Function
    End Class

    Function GetDivisors(number As Integer) As List(Of Integer)
        Dim divisors As New List(Of Integer)
        Dim root = CType(Math.Sqrt(number), Long)
        For i = 1 To root
            If number Mod i = 0 Then
                divisors.Add(i)
                Dim div = number \ i
                If div <> i AndAlso div <> number Then
                    divisors.Add(div)
                End If
            End If
        Next
        Return divisors
    End Function

    Private ReadOnly allFactors As New Dictionary(Of Integer, Dictionary(Of Integer, Integer)) From {{2, New Dictionary(Of Integer, Integer) From {{2, 1}}}}
    Function GetFactors(number As Integer) As Dictionary(Of Integer, Integer)
        If allFactors.ContainsKey(number) Then
            Return allFactors(number)
        End If

        Dim factors As New Dictionary(Of Integer, Integer)
        If number Mod 2 = 0 Then
            Dim factorsDivTwo = GetFactors(number \ 2)
            For Each pair In factorsDivTwo
                If Not factors.ContainsKey(pair.Key) Then
                    factors.Add(pair.Key, pair.Value)
                End If
            Next
            If factors.ContainsKey(2) Then
                factors(2) += 1
            Else
                factors.Add(2, 1)
            End If
            If number < MAX_ALL_FACTORS Then
                allFactors.Add(number, factors)
            End If
            Return factors
        End If
        Dim root = CType(Math.Sqrt(number), Long)
        Dim i = 3L
        While i <= root
            If number Mod i = 0 Then
                Dim factorsDivI = GetFactors(number \ i)
                For Each pair In factorsDivI
                    If Not factors.ContainsKey(pair.Key) Then
                        factors.Add(pair.Key, pair.Value)
                    End If
                Next
                If factors.ContainsKey(i) Then
                    factors(i) += 1
                Else
                    factors.Add(i, 1)
                End If
                If number < MAX_ALL_FACTORS Then
                    allFactors.Add(number, factors)
                End If
                Return factors
            End If
            i += 2
        End While
        factors.Add(number, 1)
        If number < MAX_ALL_FACTORS Then
            allFactors.Add(number, factors)
        End If
        Return factors
    End Function

    Private ReadOnly computedPolynomials As New Dictionary(Of Integer, Polynomial)
    Function CyclotomicPolynomial(n As Integer) As Polynomial
        If computedPolynomials.ContainsKey(n) Then
            Return computedPolynomials(n)
        End If

        If n = 1 Then
            REM polynomial: x - 1
            Dim p As New Polynomial(New Term(1, 1), New Term(-1))
            computedPolynomials.Add(n, p)
            Return p
        End If

        Dim factors = GetFactors(n)
        Dim terms As New List(Of Term)
        Dim cyclo As Polynomial

        If factors.ContainsKey(n) Then
            REM n prime
            For index = 1 To n
                terms.Add(New Term(1, index - 1))
            Next

            cyclo = New Polynomial(terms)
            computedPolynomials.Add(n, cyclo)
            Return cyclo
        ElseIf factors.Count = 2 AndAlso factors.ContainsKey(2) AndAlso factors(2) = 1 AndAlso factors.ContainsKey(n / 2) AndAlso factors(n / 2) = 1 Then
            REM n = 2p
            Dim prime = n \ 2
            Dim coeff = -1

            For index = 1 To prime
                coeff *= -1
                terms.Add(New Term(coeff, index - 1))
            Next

            cyclo = New Polynomial(terms)
            computedPolynomials.Add(n, cyclo)
            Return cyclo
        ElseIf factors.Count = 1 AndAlso factors.ContainsKey(2) Then
            REM n = 2^h
            Dim h = factors(2)
            terms = New List(Of Term) From {
                New Term(1, Math.Pow(2, h - 1)),
                New Term(1)
            }

            cyclo = New Polynomial(terms)
            computedPolynomials.Add(n, cyclo)
            Return cyclo
        ElseIf factors.Count = 1 AndAlso factors.ContainsKey(n) Then
            REM n = p^k
            Dim p = 0
            Dim k = 0
            For Each it In factors
                p = it.Key
                k = it.Value
            Next
            For index = 1 To p
                terms.Add(New Term(1, (index - 1) * Math.Pow(p, k - 1)))
            Next

            cyclo = New Polynomial(terms)
            computedPolynomials.Add(n, cyclo)
            Return cyclo
        ElseIf factors.Count = 2 AndAlso factors.ContainsKey(2) Then
            REM n = 2^h * p^k
            Dim p = 0
            For Each it In factors
                If it.Key <> 2 Then
                    p = it.Key
                End If
            Next

            Dim coeff = -1
            Dim twoExp = CType(Math.Pow(2, factors(2) - 1), Long)
            Dim k = factors(p)
            For index = 1 To p
                coeff *= -1
                terms.Add(New Term(coeff, (index - 1) * twoExp * Math.Pow(p, k - 1)))
            Next

            cyclo = New Polynomial(terms)
            computedPolynomials.Add(n, cyclo)
            Return cyclo
        ElseIf factors.ContainsKey(2) AndAlso (n / 2) Mod 2 = 1 AndAlso n / 2 > 1 Then
            REM CP(2m)[x] = CP(-m)[x], n odd integer > 1
            Dim cycloDiv2 = CyclotomicPolynomial(n \ 2)
            For Each t In cycloDiv2
                If t.Exponent Mod 2 = 0 Then
                    terms.Add(t)
                Else
                    terms.Add(-t)
                End If
            Next

            cyclo = New Polynomial(terms)
            computedPolynomials.Add(n, cyclo)
            Return cyclo
        End If

#If ALGORITHM = 0 Then
        REM slow - uses basic definition
        Dim divisors = GetDivisors(n)
        REM Polynomial: (x^n - 1)
        cyclo = New Polynomial(New Term(1, n), New Term(-1))
        For Each i In divisors
            Dim p = CyclotomicPolynomial(i)
            cyclo /= p
        Next

        computedPolynomials.Add(n, cyclo)
        Return cyclo
#ElseIf ALGORITHM = 1 Then
        REM Faster.  Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
        Dim divisors = GetDivisors(n)
        Dim maxDivisor = Integer.MinValue
        For Each div In divisors
            maxDivisor = Math.Max(maxDivisor, div)
        Next
        Dim divisorExceptMax As New List(Of Integer)
        For Each div In divisors
            If maxDivisor Mod div <> 0 Then
                divisorExceptMax.Add(div)
            End If
        Next

        REM Polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
        cyclo = New Polynomial(New Term(1, n), New Term(-1)) / New Polynomial(New Term(1, maxDivisor), New Term(-1))
        For Each i In divisorExceptMax
            Dim p = CyclotomicPolynomial(i)
            cyclo /= p
        Next

        computedPolynomials.Add(n, cyclo)
        Return cyclo
#ElseIf ALGORITHM = 2 Then
        REM Fastest
        REM Let p ; q be primes such that p does not divide n, and q divides n
        REM Then Cp(np)[x] = CP(n)[x^p] / CP(n)[x]
        Dim m = 1
        cyclo = CyclotomicPolynomial(m)
        Dim primes As New List(Of Integer)
        For Each it In factors
            primes.Add(it.Key)
        Next
        primes.Sort()
        For Each prime In primes
            REM CP(m)[x]
            Dim cycloM = cyclo
            REM Compute CP(m)[x^p]
            terms = New List(Of Term)
            For Each t In cyclo
                terms.Add(New Term(t.Coefficient, t.Exponent * prime))
            Next
            cyclo = New Polynomial(terms) / cycloM
            m *= prime
        Next
        REM Now, m is the largest square free divisor of n
        Dim s = n \ m
        REM Compute CP(n)[x] = CP(m)[x^s]
        terms = New List(Of Term)
        For Each t In cyclo
            terms.Add(New Term(t.Coefficient, t.Exponent * s))
        Next

        cyclo = New Polynomial(terms)
        computedPolynomials.Add(n, cyclo)
        Return cyclo
#Else
        Throw New Exception("Invalid algorithm")
#End If
    End Function

    Sub Main()
        Console.WriteLine("Task 1:  cyclotomic polynomials for n <= 30:")
        For i = 1 To 30
            Dim p = CyclotomicPolynomial(i)
            Console.WriteLine("CP[{0}] = {1}", i, p)
        Next
        Console.WriteLine()

        Console.WriteLine("Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:")
        Dim n = 0
        For i = 1 To 10
            While True
                n += 1
                Dim cyclo = CyclotomicPolynomial(n)
                If cyclo.HasCoefficentAbs(i) Then
                    Console.WriteLine("CP[{0}] has coefficient with magnitude = {1}", n, i)
                    n -= 1
                    Exit While
                End If
            End While
        Next
    End Sub

End Module
