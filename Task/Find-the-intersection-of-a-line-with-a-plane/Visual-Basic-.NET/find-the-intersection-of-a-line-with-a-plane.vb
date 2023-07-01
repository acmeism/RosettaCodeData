Module Module1

    Class Vector3D
        Private ReadOnly x As Double
        Private ReadOnly y As Double
        Private ReadOnly z As Double

        Sub New(nx As Double, ny As Double, nz As Double)
            x = nx
            y = ny
            z = nz
        End Sub

        Public Function Dot(rhs As Vector3D) As Double
            Return x * rhs.x + y * rhs.y + z * rhs.z
        End Function

        Public Shared Operator +(ByVal a As Vector3D, ByVal b As Vector3D) As Vector3D
            Return New Vector3D(a.x + b.x, a.y + b.y, a.z + b.z)
        End Operator

        Public Shared Operator -(ByVal a As Vector3D, ByVal b As Vector3D) As Vector3D
            Return New Vector3D(a.x - b.x, a.y - b.y, a.z - b.z)
        End Operator

        Public Shared Operator *(ByVal a As Vector3D, ByVal b As Double) As Vector3D
            Return New Vector3D(a.x * b, a.y * b, a.z * b)
        End Operator

        Public Overrides Function ToString() As String
            Return String.Format("({0:F}, {1:F}, {2:F})", x, y, z)
        End Function
    End Class

    Function IntersectPoint(rayVector As Vector3D, rayPoint As Vector3D, planeNormal As Vector3D, planePoint As Vector3D) As Vector3D
        Dim diff = rayPoint - planePoint
        Dim prod1 = diff.Dot(planeNormal)
        Dim prod2 = rayVector.Dot(planeNormal)
        Dim prod3 = prod1 / prod2
        Return rayPoint - rayVector * prod3
    End Function

    Sub Main()
        Dim rv = New Vector3D(0.0, -1.0, -1.0)
        Dim rp = New Vector3D(0.0, 0.0, 10.0)
        Dim pn = New Vector3D(0.0, 0.0, 1.0)
        Dim pp = New Vector3D(0.0, 0.0, 5.0)
        Dim ip = IntersectPoint(rv, rp, pn, pp)
        Console.WriteLine("The ray intersects the plane at {0}", ip)
    End Sub

End Module
