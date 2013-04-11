using System;

static class Program
{
    static void Main(string[] args)
    {
        Quaternion q = new Quaternion(1, 2, 3, 4);
        Quaternion q1 = new Quaternion(2, 3, 4, 5);
        Quaternion q2 = new Quaternion(3, 4, 5, 6);
        double r = 7;

        Console.WriteLine("q = {0}", q);
        Console.WriteLine("q1 = {0}", q1);
        Console.WriteLine("q2 = {0}", q2);
        Console.WriteLine("r = {0}", r);

        Console.WriteLine("q.Norm() = {0}", q.Norm());
        Console.WriteLine("q1.Norm() = {0}", q1.Norm());
        Console.WriteLine("q2.Norm() = {0}", q2.Norm());

        Console.WriteLine("-q = {0}", -q);
        Console.WriteLine("q.Conjugate() = {0}", q.Conjugate());

        Console.WriteLine("q + r = {0}", q + r);
        Console.WriteLine("q1 + q2 = {0}", q1 + q2);
        Console.WriteLine("q2 + q1 = {0}", q2 + q1);

        Console.WriteLine("q * r = {0}", q * r);
        Console.WriteLine("q1 * q2 = {0}", q1 * q2);
        Console.WriteLine("q2 * q1 = {0}", q2 * q1);

        Console.WriteLine("q1*q2 {0} q2*q1", (q1 * q2) == (q2 * q1) ? "==" : "!=");
    }
}
