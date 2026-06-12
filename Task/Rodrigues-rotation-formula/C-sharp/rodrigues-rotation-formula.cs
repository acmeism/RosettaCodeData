using System;

public sealed class RodriguesRotationFormula
{
    public static void Main(string[] args)
    {
        Vector axis = new Vector(-1.0, 2.0, 1.0);
        Vector vector = new Vector(2.5, -1.5, 3.0);

        Console.WriteLine(" Angle         Rotated vector");
        Console.WriteLine("-----------------------------------");
        for (double theta = 0.0; theta <= 2.0 * Math.PI; theta += Math.PI / 5.0)
        {
            Vector result = axis.RodriguesRotation(vector, theta);
            Console.WriteLine($"{theta:F4}    {result}");
        }
    }
}

public sealed class Vector
{
    private readonly double x, y, z;

    public Vector(double aX, double aY, double aZ)
    {
        x = aX;
        y = aY;
        z = aZ;
    }

    public Vector UnitVector()
    {
        return ScalarMultiply(1.0 / Math.Sqrt(DotProduct(this)));
    }

    public Vector Add(Vector other)
    {
        return new Vector(x + other.x, y + other.y, z + other.z);
    }

    public Vector ScalarMultiply(double value)
    {
        return new Vector(x * value, y * value, z * value);
    }

    public double DotProduct(Vector other)
    {
        return x * other.x + y * other.y + z * other.z;
    }

    public Vector CrossProduct(Vector other)
    {
        return new Vector(y * other.z - z * other.y,
                         z * other.x - x * other.z,
                         x * other.y - y * other.x);
    }

    public Vector RodriguesRotation(Vector vector, double angle)
    {
        Vector axis = UnitVector();
        return vector.ScalarMultiply(Math.Cos(angle))
            .Add(axis.CrossProduct(vector).ScalarMultiply(Math.Sin(angle)))
            .Add(axis.ScalarMultiply(axis.DotProduct(vector) * (1.0 - Math.Cos(angle))));
    }

    public override string ToString()
    {
        return $"({x:F4}, {y:F4}, {z:F4})";
    }
}
