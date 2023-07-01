using System;

namespace RosettaMaybe
{
    // courtesy of https://www.dotnetcurry.com/patterns-practices/1510/maybe-monad-csharp
    public abstract class Maybe<T>
    {
        public sealed class Some : Maybe<T>
        {
            public Some(T value) => Value = value;
            public T Value { get; }
        }
        public sealed class None : Maybe<T> { }
    }

    class Program
    {
        static Maybe<double> MonadicSquareRoot(double x)
        {
            if (x >= 0)
            {
                return new Maybe<double>.Some(Math.Sqrt(x));
            }
            else
            {
                return new Maybe<double>.None();
            }
        }
        static void Main(string[] args)
        {
            foreach (double x in new double[] { 4.0D, 8.0D, -15.0D, 16.23D, -42 })
            {
                Maybe<double> maybe = MonadicSquareRoot(x);
                if (maybe is Maybe<double>.Some some)
                {
                    Console.WriteLine($"The square root of {x} is " + some.Value);
                }
                else
                {
                    Console.WriteLine($"Square root of {x} is undefined.");
                }
            }
        }
    }
}
