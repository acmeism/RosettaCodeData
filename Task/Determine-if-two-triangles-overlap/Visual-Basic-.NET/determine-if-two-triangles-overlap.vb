Module Module1

    Class Triangle
        Property P1 As Tuple(Of Double, Double)
        Property P2 As Tuple(Of Double, Double)
        Property P3 As Tuple(Of Double, Double)

        Sub New(p1 As Tuple(Of Double, Double), p2 As Tuple(Of Double, Double), p3 As Tuple(Of Double, Double))
            Me.P1 = p1
            Me.P2 = p2
            Me.P3 = p3
        End Sub

        Function Det2D() As Double
            Return P1.Item1 * (P2.Item2 - P3.Item2) +
                   P2.Item1 * (P3.Item2 - P1.Item2) +
                   P3.Item1 * (P1.Item2 - P2.Item2)
        End Function

        Sub CheckTriWinding(allowReversed As Boolean)
            Dim detTri = Det2D()
            If detTri < 0.0 Then
                If allowReversed Then
                    Dim a = P3
                    P3 = P2
                    P2 = a
                Else
                    Throw New Exception("Triangle has wrong winding direction")
                End If
            End If
        End Sub

        Function BoundaryCollideChk(eps As Double) As Boolean
            Return Det2D() < eps
        End Function

        Function BoundaryDoesntCollideChk(eps As Double) As Boolean
            Return Det2D() <= eps
        End Function

        Public Overrides Function ToString() As String
            Return String.Format("Triangle: {0}, {1}, {2}", P1, P2, P3)
        End Function
    End Class

    Function TriTri2D(t1 As Triangle, t2 As Triangle, Optional eps As Double = 0.0, Optional alloweReversed As Boolean = False, Optional onBoundary As Boolean = True) As Boolean
        'Triangles must be expressed anti-clockwise
        t1.CheckTriWinding(alloweReversed)
        t2.CheckTriWinding(alloweReversed)

        '"onboundary" determines whether points on boundary are considered as colliding or not
        Dim chkEdge = If(onBoundary, Function(t As Triangle) t.BoundaryCollideChk(eps), Function(t As Triangle) t.BoundaryDoesntCollideChk(eps))
        Dim lp1 As New List(Of Tuple(Of Double, Double)) From {t1.P1, t1.P2, t1.P3}
        Dim lp2 As New List(Of Tuple(Of Double, Double)) From {t2.P1, t2.P2, t2.P3}

        'for each edge E of t1
        For i = 0 To 2
            Dim j = (i + 1) Mod 3
            'Check all points of t2 lay on the external side of edge E.
            'If they do, the triangles do not overlap.
            If chkEdge(New Triangle(lp1(i), lp1(j), lp2(0))) AndAlso
               chkEdge(New Triangle(lp1(i), lp1(j), lp2(1))) AndAlso
               chkEdge(New Triangle(lp1(i), lp1(j), lp2(2))) Then
                Return False
            End If
        Next

        'for each edge E of t2
        For i = 0 To 2
            Dim j = (i + 1) Mod 3
            'Check all points of t1 lay on the external side of edge E.
            'If they do, the triangles do not overlap.
            If chkEdge(New Triangle(lp2(i), lp2(j), lp1(0))) AndAlso
               chkEdge(New Triangle(lp2(i), lp2(j), lp1(1))) AndAlso
               chkEdge(New Triangle(lp2(i), lp2(j), lp1(2))) Then
                Return False
            End If
        Next

        'The triangles overlap
        Return True
    End Function

    Sub Overlap(t1 As Triangle, t2 As Triangle, Optional eps As Double = 0.0, Optional allowReversed As Boolean = False, Optional onBoundary As Boolean = True)
        If TriTri2D(t1, t2, eps, allowReversed, onBoundary) Then
            Console.WriteLine("overlap")
        Else
            Console.WriteLine("do not overlap")
        End If
    End Sub

    Sub Main()
        Dim t1 = New Triangle(Tuple.Create(0.0, 0.0), Tuple.Create(5.0, 0.0), Tuple.Create(0.0, 5.0))
        Dim t2 = New Triangle(Tuple.Create(0.0, 0.0), Tuple.Create(5.0, 0.0), Tuple.Create(0.0, 6.0))
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Overlap(t1, t2)
        Console.WriteLine()

        ' need to allow reversed for this pair to avoid exception
        t1 = New Triangle(Tuple.Create(0.0, 0.0), Tuple.Create(0.0, 5.0), Tuple.Create(5.0, 0.0))
        t2 = t1
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Overlap(t1, t2, 0.0, True)
        Console.WriteLine()

        t1 = New Triangle(Tuple.Create(0.0, 0.0), Tuple.Create(5.0, 0.0), Tuple.Create(0.0, 5.0))
        t2 = New Triangle(Tuple.Create(-10.0, 0.0), Tuple.Create(-5.0, 0.0), Tuple.Create(-1.0, 6.0))
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Overlap(t1, t2)
        Console.WriteLine()

        t1.P3 = Tuple.Create(2.5, 5.0)
        t2 = New Triangle(Tuple.Create(0.0, 4.0), Tuple.Create(2.5, -1.0), Tuple.Create(5.0, 4.0))
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Overlap(t1, t2)
        Console.WriteLine()

        t1 = New Triangle(Tuple.Create(0.0, 0.0), Tuple.Create(1.0, 1.0), Tuple.Create(0.0, 2.0))
        t2 = New Triangle(Tuple.Create(2.0, 1.0), Tuple.Create(3.0, 0.0), Tuple.Create(3.0, 2.0))
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Overlap(t1, t2)
        Console.WriteLine()

        t2 = New Triangle(Tuple.Create(2.0, 1.0), Tuple.Create(3.0, -2.0), Tuple.Create(3.0, 4.0))
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Overlap(t1, t2)
        Console.WriteLine()

        t1 = New Triangle(Tuple.Create(0.0, 0.0), Tuple.Create(1.0, 0.0), Tuple.Create(0.0, 1.0))
        t2 = New Triangle(Tuple.Create(1.0, 0.0), Tuple.Create(2.0, 0.0), Tuple.Create(1.0, 1.1))
        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Console.WriteLine("which have only a single corner in contact, if boundary points collide")
        Overlap(t1, t2)
        Console.WriteLine()

        Console.WriteLine("{0} and", t1)
        Console.WriteLine("{0}", t2)
        Console.WriteLine("which have only a single corner in contact, if boundary points do not collide")
        Overlap(t1, t2, 0.0, False, False)
    End Sub

End Module
