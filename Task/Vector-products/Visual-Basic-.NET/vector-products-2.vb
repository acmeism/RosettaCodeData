Module Module1

    Sub Main()
        Dim v1 As New Vector3D(3, 4, 5)
        Dim v2 As New Vector3D(4, 3, 5)
        Dim v3 As New Vector3D(-5, -12, -13)

        Console.WriteLine("v1: {0}", v1.ToString())
        Console.WriteLine("v2: {0}", v2.ToString())
        Console.WriteLine("v3: {0}", v3.ToString())
        Console.WriteLine()

        Console.WriteLine("v1 . v2 = {0}", v1.Dot(v2))
        Console.WriteLine("v1 x v2 = {0}", v1.Cross(v2).ToString())
        Console.WriteLine("v1 . (v2 x v3) = {0}", v1.ScalarTriple(v2, v3))
        Console.WriteLine("v1 x (v2 x v3) = {0}", v1.VectorTriple(v2, v3))
    End Sub

End Module
