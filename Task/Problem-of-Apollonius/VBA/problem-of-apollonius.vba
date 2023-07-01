Option Explicit
Option Base 0

Private Const intBase As Integer = 0

Private Type tPoint
	X As Double
	Y As Double
End Type
Private Type tCircle
	Centre As tPoint
	Radius As Double
End Type

Private Sub sApollonius()
    Dim Circle1 As tCircle
    Dim Circle2 As tCircle
    Dim Circle3 As tCircle
    Dim CTanTanTan(intBase + 0 to intBase + 7) As tCircle

    With Circle1
        With .Centre
            .X = 0
            .Y = 0
        End With
        .Radius = 1
    End With

    With Circle2
        With .Centre
            .X = 4
            .Y = 0
        End With
        .Radius = 1
    End With

    With Circle3
        With .Centre
            .X = 2
            .Y = 4
        End With
        .Radius = 2
    End With

    Call fApollonius(Circle1,Circle2,Circle3,CTanTanTan()))

End Sub

Public Function fApollonius(ByRef C1 As tCircle, _
                            ByRef C2 As tCircle, _
                            ByRef C3 As tCircle, _
                            ByRef CTanTanTan() As tCircle) As Boolean
' Solves the Problem of Apollonius (finding a circle tangent to three other circles in the plane)
' (x_s - x_1)^2 + (y_s - y_1)^2 = (r_s - Tan_1 * r_1)^2
' (x_s - x_2)^2 + (y_s - y_2)^2 = (r_s - Tan_2 * r_2)^2
' (x_s - x_3)^2 + (y_s - y_3)^2 = (r_s - Tan_3 * r_3)^2
' x_s = M + N * r_s
' y_s = P + Q * r_s

' Parameters:
'   C1, C2, C3 (circles in the problem)
'   Tan1 := An indication if the solution should be externally or internally tangent (+1/-1) to Circle1 (C1)
'   Tan2 := An indication if the solution should be externally or internally tangent (+1/-1) to Circle2 (C2)
'   Tan3 := An indication if the solution should be externally or internally tangent (+1/-1) to Circle3 (C3)

    Dim Tangent(intBase + 0 To intBase + 7, intBase + 0 To intBase + 2) As Integer
    Dim lgTangent As Long
    Dim Tan1 As Integer
    Dim Tan2 As Integer
    Dim Tan3 As Integer

    Dim v11 As Double
    Dim v12 As Double
    Dim v13 As Double
    Dim v14 As Double
    Dim v21 As Double
    Dim v22 As Double
    Dim v23 As Double
    Dim v24 As Double
    Dim w12 As Double
    Dim w13 As Double
    Dim w14 As Double
    Dim w22 As Double
    Dim w23 As Double
    Dim w24 As Double

    Dim p As Double
    Dim Q As Double
    Dim M As Double
    Dim N As Double

    Dim A As Double
    Dim b As Double
    Dim c As Double
    Dim D As Double

    'Check if circle centers are colinear
    If fColinearPoints(C1.Centre, C2.Centre, C3.Centre) Then
        fApollonius = False
        Exit Function
    End If

    Tangent(intBase + 0, intBase + 0) = -1
    Tangent(intBase + 0, intBase + 1) = -1
    Tangent(intBase + 0, intBase + 2) = -1

    Tangent(intBase + 1, intBase + 0) = -1
    Tangent(intBase + 1, intBase + 1) = -1
    Tangent(intBase + 1, intBase + 2) = 1

    Tangent(intBase + 2, intBase + 0) = -1
    Tangent(intBase + 2, intBase + 1) = 1
    Tangent(intBase + 2, intBase + 2) = -1

    Tangent(intBase + 3, intBase + 0) = -1
    Tangent(intBase + 3, intBase + 1) = 1
    Tangent(intBase + 3, intBase + 2) = 1

    Tangent(intBase + 4, intBase + 0) = 1
    Tangent(intBase + 4, intBase + 1) = -1
    Tangent(intBase + 4, intBase + 2) = -1

    Tangent(intBase + 5, intBase + 0) = 1
    Tangent(intBase + 5, intBase + 1) = -1
    Tangent(intBase + 5, intBase + 2) = 1

    Tangent(intBase + 6, intBase + 0) = 1
    Tangent(intBase + 6, intBase + 1) = 1
    Tangent(intBase + 6, intBase + 2) = -1

    Tangent(intBase + 7, intBase + 0) = 1
    Tangent(intBase + 7, intBase + 1) = 1
    Tangent(intBase + 7, intBase + 2) = 1

    For lgTangent = LBound(Tangent) To UBound(Tangent)
        Tan1 = Tangent(lgTangent, intBase + 0)
        Tan2 = Tangent(lgTangent, intBase + 1)
        Tan3 = Tangent(lgTangent, intBase + 2)

        v11 = 2 * (C2.Centre.X - C1.Centre.X)
        v12 = 2 * (C2.Centre.Y - C1.Centre.Y)
        v13 = (C1.Centre.X * C1.Centre.X) _
            - (C2.Centre.X * C2.Centre.X) _
            + (C1.Centre.Y * C1.Centre.Y) _
            - (C2.Centre.Y * C2.Centre.Y) _
            - (C1.Radius * C1.Radius) _
            + (C2.Radius * C2.Radius)
        v14 = 2 * (Tan2 * C2.Radius - Tan1 * C1.Radius)

        v21 = 2 * (C3.Centre.X - C2.Centre.X)
        v22 = 2 * (C3.Centre.Y - C2.Centre.Y)
        v23 = (C2.Centre.X * C2.Centre.X) _
            - (C3.Centre.X * C3.Centre.X) _
            + (C2.Centre.Y * C2.Centre.Y) _
            - (C3.Centre.Y * C3.Centre.Y) _
            - (C2.Radius * C2.Radius) _
            + (C3.Radius * C3.Radius)
        v24 = 2 * ((Tan3 * C3.Radius) - (Tan2 * C2.Radius))

        w12 = v12 / v11
        w13 = v13 / v11
        w14 = v14 / v11

        w22 = (v22 / v21) - w12
        w23 = (v23 / v21) - w13
        w24 = (v24 / v21) - w14

        p = -w23 / w22
        Q = w24 / w22
        M = -(w12 * p) - w13
        N = w14 - (w12 * Q)

        A = (N * N) + (Q * Q) - 1
        b = 2 * ((M * N) - (N * C1.Centre.X) + (p * Q) - (Q * C1.Centre.Y) + (Tan1 * C1.Radius))
        c = (C1.Centre.X * C1.Centre.X) _
          + (M * M) _
          - (2 * M * C1.Centre.X) _
          + (p * p) _
          + (C1.Centre.Y * C1.Centre.Y) _
          - (2 * p * C1.Centre.Y) _
          - (C1.Radius * C1.Radius)

        'Find a root of a quadratic equation (requires the circle centers not to be e.g. colinear)
        D = (b * b) - (4 * A * c)

        With CTanTanTan(lgTangent)
            .Radius = (-b - VBA.Sqr(D)) / (2 * A)
            .Centre.X = M + (N * .Radius)
            .Centre.Y = p + (Q * .Radius)
        End With

    Next lgTangent

    fApollonius = True

End Function
