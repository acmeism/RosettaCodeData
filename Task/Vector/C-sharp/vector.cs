using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaVectors
{
    public class Vector
    {
        public double[] store;
        public Vector(IEnumerable<double> init)
        {
            store = init.ToArray();
        }
        public Vector(double x, double y)
        {
            store = new double[] { x, y };
        }
        static public Vector operator+(Vector v1, Vector v2)
        {
            return new Vector(v1.store.Zip(v2.store, (a, b) => a + b));
        }
        static public Vector operator -(Vector v1, Vector v2)
        {
            return new Vector(v1.store.Zip(v2.store, (a, b) => a - b));
        }
        static public Vector operator *(Vector v1, double scalar)
        {
            return new Vector(v1.store.Select(x => x * scalar));
        }
        static public Vector operator /(Vector v1, double scalar)
        {
            return new Vector(v1.store.Select(x => x / scalar));
        }
        public override string ToString()
        {
            return string.Format("[{0}]", string.Join(",", store));
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            var v1 = new Vector(5, 7);
            var v2 = new Vector(2, 3);
            Console.WriteLine(v1 + v2);
            Console.WriteLine(v1 - v2);
            Console.WriteLine(v1 * 11);
            Console.WriteLine(v1 / 2);
            // Works with arbitrary size vectors, too.
            var lostVector = new Vector(new double[] { 4, 8, 15, 16, 23, 42 });
            Console.WriteLine(lostVector * 7);
            Console.ReadLine();
        }
    }
}
