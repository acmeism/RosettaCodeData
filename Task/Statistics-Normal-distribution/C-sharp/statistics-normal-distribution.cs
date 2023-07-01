using System;
using MathNet.Numerics.Distributions;
using MathNet.Numerics.Statistics;

class Program
{
    static void RunNormal(int sampleSize)
    {
        double[] X = new double[sampleSize];
        var norm = new Normal(new Random());
        norm.Samples(X);

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
        RunNormal(100);
        RunNormal(1000);
        RunNormal(10000);
    }
}
