using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using static System.Math;

namespace RosettaCode;

class Program
{
    private const int SecondsPerDay = 60 * 60 * 24;

    static void Main()
    {
        var digitimes = new List<TimeSpan>();

        Console.WriteLine("Enter times, end with no input: ");
        while (true) {
            string input = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(input)) break;
            if (TimeSpan.TryParse(input, out var digitime)) {
                digitimes.Add(digitime);
            } else {
                Console.WriteLine("Seems this is wrong input: ignoring time");
            }
        }
        if(digitimes.Count() > 0)
            Console.WriteLine($"The mean time is : {MeanTime(digitimes)}");
    }

    public static TimeSpan MeanTime(IEnumerable<TimeSpan> ts) => FromDegrees(MeanAngle(ts.Select(ToDegrees)));
    public static double ToDegrees(TimeSpan ts) => ts.TotalSeconds * 360d / SecondsPerDay;
    public static TimeSpan FromDegrees(double degrees) => TimeSpan.FromSeconds((int)(degrees * SecondsPerDay / 360));

    public static double MeanAngle(IEnumerable<double> angles)
    {
        var x = angles.Average(a => Cos(a * PI / 180));
        var y = angles.Average(a => Sin(a * PI / 180));
        return (Atan2(y, x) * 180 / PI + 360) % 360;
    }
}
