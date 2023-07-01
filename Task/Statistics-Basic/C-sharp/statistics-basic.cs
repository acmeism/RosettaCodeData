using System;
using MathNet.Numerics.Statistics;

class Program
{
    static void Run(int sampleSize)
    {
        double[] X = new double[sampleSize];
        var r = new Random();
        for (int i = 0; i < sampleSize; i++)
            X[i] = r.NextDouble();

        const int numBuckets = 10;
        var histogram = new Histogram(X, numBuckets);
        Console.WriteLine("Sample size: {0:N0}", sampleSize);
        for (int i = 0; i < numBuckets; i++)
        {
            string bar = new String('#', (int)(histogram[i].Count * 360 / sampleSize));
            Console.WriteLine(" {0:0.00} : {1}", histogram[i].LowerBound, bar);
        }
        var statistics = new DescriptiveStatistics(X);
        Console.WriteLine("  Mean: " + statistics.Mean);
        Console.WriteLine("StdDev: " + statistics.StandardDeviation);
        Console.WriteLine();
    }
    static void Main(string[] args)
    {
        Run(100);
        Run(1000);
        Run(10000);
    }
}
