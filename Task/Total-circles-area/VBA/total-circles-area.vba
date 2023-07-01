Public c As Variant
Public pi As Double
Dim arclists() As Variant
Public Enum circles_
    xc = 0
    yc
    rc
End Enum
Public Enum arclists_
    rho
    x_
    y_
    i_
End Enum
Public Enum shoelace_axis
    u = 0
    v
End Enum
Private Sub give_a_list_of_circles()
    c = Array(Array(1.6417233788, 1.6121789534, 0.0848270516), _
    Array(-1.4944608174, 1.2077959613, 1.1039549836), _
    Array(0.6110294452, -0.6907087527, 0.9089162485), _
    Array(0.3844862411, 0.2923344616, 0.2375743054), _
    Array(-0.249589295, -0.3832854473, 1.0845181219), _
    Array(1.7813504266, 1.6178237031, 0.8162655711), _
    Array(-0.1985249206, -0.8343333301, 0.0538864941), _
    Array(-1.7011985145, -0.1263820964, 0.4776976918), _
    Array(-0.4319462812, 1.4104420482, 0.7886291537), _
    Array(0.2178372997, -0.9499557344, 0.0357871187), _
    Array(-0.6294854565, -1.3078893852, 0.7653357688), _
    Array(1.7952608455, 0.6281269104, 0.2727652452), _
    Array(1.4168575317, 1.0683357171, 1.1016025378), _
    Array(1.4637371396, 0.9463877418, 1.1846214562), _
    Array(-0.5263668798, 1.7315156631, 1.4428514068), _
    Array(-1.2197352481, 0.9144146579, 1.0727263474), _
    Array(-0.1389358881, 0.109280578, 0.7350208828), _
    Array(1.5293954595, 0.0030278255, 1.2472867347), _
    Array(-0.5258728625, 1.3782633069, 1.3495508831), _
    Array(-0.1403562064, 0.2437382535, 1.3804956588), _
    Array(0.8055826339, -0.0482092025, 0.3327165165), _
    Array(-0.6311979224, 0.7184578971, 0.2491045282), _
    Array(1.4685857879, -0.8347049536, 1.3670667538), _
    Array(-0.6855727502, 1.6465021616, 1.0593087096), _
    Array(0.0152957411, 0.0638919221, 0.9771215985))
    pi = WorksheetFunction.pi()
End Sub
Private Function shoelace(s As Collection) As Double
    's is a collection of coordinate pairs (x, y),
    'in clockwise order for positive result.
    'The last pair is identical to the first pair.
    'These pairs map a polygonal area.
    'The area is computed with the shoelace algoritm.
    'see the Rosetta Code task.
    Dim t As Double
    If s.Count > 2 Then
        s.Add s(1)
        For i = 1 To s.Count - 1
            t = t + s(i + 1)(u) * s(i)(v) - s(i)(u) * s(i + 1)(v)
        Next i
    End If
    shoelace = t / 2
End Function
Private Sub arc_sub(acol As Collection, f0 As Double, u0 As Double, v0 As Double, _
    f1 As Double, u1 As Double, v1 As Double, this As Integer, j As Integer)
    'subtract the arc from f0 to f1 from the arclist acol
    'complicated to deal with edge cases
    If acol.Count = 0 Then Exit Sub 'nothing to subtract from
    Debug.Assert acol.Count Mod 2 = 0
    Debug.Assert f0 <> f1
    If f1 = pi Or f1 + pi < 5E-16 Then f1 = -f1
    If f0 = pi Or f0 + pi < 5E-16 Then f0 = -f0
    If f0 < f1 Then
        'the arc does not pass the negative x-axis
        'find a such that acol(a)(0)<f0<acol(a+1)(0)
        ' and b such that acol(b)(0)<f1<acol(b+1)(0)
        If f1 < acol(1)(rho) Or f0 > acol(acol.Count)(rho) Then Exit Sub 'nothing to subtract
        i = acol.Count + 1
        start = 1
        Do
            i = i - 1
        Loop Until f1 > acol(i)(rho)
        If i Mod 2 = start Then
            acol.Add Array(f1, u1, v1, j), after:=i
        End If
        i = 0
        Do
            i = i + 1
        Loop Until f0 < acol(i)(rho)
        If i Mod 2 = 1 - start Then
            acol.Add Array(f0, u0, v0, j), before:=i
            i = i + 1
        End If
        Do While acol(i)(rho) < f1
            acol.Remove i
            If i > acol.Count Then Exit Do
        Loop
    Else
        start = 1
        If f0 > acol(1)(rho) Then
            i = acol.Count + 1
            Do
                i = i - 1
            Loop While f0 < acol(i)(0)
            If f0 = pi Then
                acol.Add Array(f0, u0, v0, j), before:=i
            Else
                If i Mod 2 = start Then
                    acol.Add Array(f0, u0, v0, j), after:=i
                End If
            End If
        End If
        If f1 <= acol(acol.Count)(rho) Then
            i = 0
            Do
                i = i + 1
            Loop While f1 > acol(i)(rho)
            If f1 + pi < 5E-16 Then
                acol.Add Array(f1, u1, v1, j), after:=i
            Else
                If i Mod 2 = 1 - start Then
                    acol.Add Array(f1, u1, v1, j), before:=i
                End If
            End If
        End If
        Do While acol(acol.Count)(rho) > f0 Or acol(acol.Count)(i_) = -1
            acol.Remove acol.Count
            If acol.Count = 0 Then Exit Do
        Loop
        If acol.Count > 0 Then
            Do While acol(1)(rho) < f1 Or (f1 = -pi And acol(1)(i_) = this)
                acol.Remove 1
                If acol.Count = 0 Then Exit Do
            Loop
        End If
    End If
End Sub
Private Sub circle_cross()
    ReDim arclists(LBound(c) To UBound(c))
    Dim alpha As Double, beta As Double
    Dim x3 As Double, x4 As Double, y3 As Double, y4 As Double
    Dim i As Integer, j As Integer
    For i = LBound(c) To UBound(c)
        Dim arccol As New Collection
        'arccol is a collection or surviving arcs of circle i.
        'It starts with the full circle. The collection
        'alternates between start and ending angles of the arcs.
        'This winds counter clockwise.
        'Noted are angle, x coordinate, y coordinate and
        'index number of circles with which circle i
        'intersects at that angle and -1 marks visited. This defines
        'ultimately a double linked list. So winding
        'clockwise in the end is easy.
        arccol.Add Array(-pi, c(i)(xc) - c(i)(r), c(i)(yc), i)
        arccol.Add Array(pi, c(i)(xc) - c(i)(r), c(i)(yc), -1)
        For j = LBound(c) To UBound(c)
            If i <> j Then
                x0 = c(i)(xc)
                y0 = c(i)(yc)
                r0 = c(i)(rc)
                x1 = c(j)(xc)
                y1 = c(j)(yc)
                r1 = c(j)(rc)
                d = Sqr((x0 - x1) ^ 2 + (y0 - y1) ^ 2)
                'Ignore 0 and 1, we need only the 2 case.
                If d >= r0 + r1 Or d <= Abs(r0 - r1) Then
                    'no intersections
                Else
                    a = (r0 ^ 2 - r1 ^ 2 + d ^ 2) / (2 * d)
                    h = Sqr(r0 ^ 2 - a ^ 2)
                    x2 = x0 + a * (x1 - x0) / d
                    y2 = y0 + a * (y1 - y0) / d
                    x3 = x2 + h * (y1 - y0) / d
                    y3 = y2 - h * (x1 - x0) / d
                    alpha = WorksheetFunction.Atan2(x3 - x0, y3 - y0)
                    x4 = x2 - h * (y1 - y0) / d
                    y4 = y2 + h * (x1 - x0) / d
                    beta = WorksheetFunction.Atan2(x4 - x0, y4 - y0)
                    'alpha is counterclockwise positioned w.r.t beta
                    'so the arc from beta to alpha (ccw) has to be
                    'subtracted from the list of surviving arcs as
                    'this arc lies fully in circle j
                    arc_sub arccol, alpha, x3, y3, beta, x4, y4, i, j
                End If
            End If
        Next j
        Set arclists(i) = arccol
        Set arccol = Nothing
    Next i
End Sub
Private Sub make_path()
    Dim pathcol As New Collection, arcsum As Double
    i0 = UBound(arclists)
    finished = False
    Do While True
        arcsum = 0
        Do While arclists(i0).Count = 0
            i0 = i0 - 1
        Loop
        j0 = arclists(i0).Count
        next_i = i0
        next_j = j0
        Do While True
            x = arclists(next_i)(next_j)(x_)
            y = arclists(next_i)(next_j)(y_)
            pathcol.Add Array(x, y)
            prev_i = next_i
            prev_j = next_j
            If arclists(next_i)(next_j - 1)(i_) = next_i Then
                'skip the join point at the negative x-axis
                next_j = arclists(next_i).Count - 1
                If next_j = 1 Then Exit Do 'loose full circle arc
            Else
                next_j = next_j - 1
            End If
            '------------------------------
            r = c(next_i)(rc)
            a1 = arclists(next_i)(prev_j)(rho)
            a2 = arclists(next_i)(next_j)(rho)
            If a1 > a2 Then
                alpha = a1 - a2
            Else
                alpha = 2 * pi - a2 + a1
            End If
            arcsum = arcsum + r * r * (alpha - Sin(alpha)) / 2
            '------------------------------
            next_i = arclists(next_i)(next_j)(i_)
            next_j = arclists(next_i).Count
            If next_j = 0 Then Exit Do 'skip loose arcs
            Do While arclists(next_i)(next_j)(i_) <> prev_i
                'find the matching item
                next_j = next_j - 1
            Loop
            If next_i = i0 And next_j = j0 Then
                finished = True
                Exit Do
            End If
        Loop
        If finished Then Exit Do
        i0 = i0 - 1
        Set pathcol = Nothing
    Loop
    Debug.Print shoelace(pathcol) + arcsum
End Sub
Public Sub total_circles()
    give_a_list_of_circles
    circle_cross
    make_path
End Sub
