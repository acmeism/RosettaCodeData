using System;
using System.Windows.Media.Media3D;

class VectorProducts
{
    static double ScalarTripleProduct(Vector3D a, Vector3D b, Vector3D c)
    {
        return Vector3D.DotProduct(a, Vector3D.CrossProduct(b, c));
    }

    static Vector3D VectorTripleProduct(Vector3D a, Vector3D b, Vector3D c)
    {
        return Vector3D.CrossProduct(a, Vector3D.CrossProduct(b, c));
    }

    static void Main()
    {
        var a = new Vector3D(3, 4, 5);
        var b = new Vector3D(4, 3, 5);
        var c = new Vector3D(-5, -12, -13);

        Console.WriteLine(Vector3D.DotProduct(a, b));
        Console.WriteLine(Vector3D.CrossProduct(a, b));
        Console.WriteLine(ScalarTripleProduct(a, b, c));
        Console.WriteLine(VectorTripleProduct(a, b, c));
    }
}
