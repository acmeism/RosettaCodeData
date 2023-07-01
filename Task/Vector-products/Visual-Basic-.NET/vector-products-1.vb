Public Class Vector3D
    Private _x, _y, _z As Double

    Public Sub New(ByVal X As Double, ByVal Y As Double, ByVal Z As Double)
        _x = X
        _y = Y
        _z = Z
    End Sub

    Public Property X() As Double
        Get
            Return _x
        End Get
        Set(ByVal value As Double)
            _x = value
        End Set
    End Property

    Public Property Y() As Double
        Get
            Return _y
        End Get
        Set(ByVal value As Double)
            _y = value
        End Set
    End Property

    Public Property Z() As Double
        Get
            Return _z
        End Get
        Set(ByVal value As Double)
            _z = value
        End Set
    End Property

    Public Function Dot(ByVal v2 As Vector3D) As Double
        Return (X * v2.X) + (Y * v2.Y) + (Z * v2.Z)
    End Function

    Public Function Cross(ByVal v2 As Vector3D) As Vector3D
        Return New Vector3D((Y * v2.Z) - (Z * v2.Y), _
                            (Z * v2.X) - (X * v2.Z), _
                            (X * v2.Y) - (Y * v2.X))
    End Function

    Public Function ScalarTriple(ByVal v2 As Vector3D, ByVal v3 As Vector3D) As Double
        Return Me.Dot(v2.Cross(v3))
    End Function

    Public Function VectorTriple(ByRef v2 As Vector3D, ByVal v3 As Vector3D) As Vector3D
        Return Me.Cross(v2.Cross(v3))
    End Function

    Public Overrides Function ToString() As String
        Return String.Format("({0}, {1}, {2})", _x, _y, _z)
    End Function
End Class
