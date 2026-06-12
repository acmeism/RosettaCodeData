Imports DT = System.DateTime

Module Module1

    Iterator Function Primes(lim As Integer) As IEnumerable(Of Integer)
        Dim flags(lim) As Boolean

        Dim j = 2

        Dim d = 3
        Dim sq = 4
        While sq <= lim
            If Not flags(j) Then
                Yield j
                For k = sq To lim Step j
                    flags(k) = True
                Next
            End If

            j += 1
            d += 2
            sq += d
        End While

        While j <= lim
            If Not flags(j) Then
                Yield j
            End If
            j += 1
        End While
    End Function

    Sub Main()
        For Each lmt In {90, 300, 3000, 30000, 111000}
            Dim pr = Primes(lmt).Skip(1).ToList()
            Dim st = DT.Now
            Dim f = 0
            Dim r As New List(Of String)
            Dim i = -1
            Dim m = lmt \ 3
            Dim h = m
            While i < 0
                i = pr.IndexOf(h)
                h -= 1
            End While
            Dim j = i - 1
            Dim k = j - 1
            For a = 0 To k
                Dim pra = pr(a)
                For b = a + 1 To j
                    Dim prab = pra + pr(b)
                    For c = b + 1 To i
                        Dim d = prab + pr(c)
                        If Not pr.Contains(d) Then
                            Continue For
                        End If
                        f += 1
                        If lmt < 100 Then
                            r.Add(String.Format("{3,5} = {0,2} + {1,2} + {2,2}", pra, pr(b), pr(c), d))
                        End If
                    Next
                Next
            Next
            Dim s = "s.u.p.t.s under "
            r.Sort()
            If r.Count > 0 Then
                Console.WriteLine("{0}{1}:" + vbNewLine + "{2}", s, m, String.Join(vbNewLine, r))
            End If
            If lmt > 100 Then
                Console.WriteLine("Count of {0}{1,6:n0}: {2,13:n0}  {3} sec", s, m, f, (DT.Now - st).ToString().Substring(6))
            End If
        Next
    End Sub

End Module
