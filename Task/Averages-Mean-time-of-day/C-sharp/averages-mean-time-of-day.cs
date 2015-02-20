using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RosettaCode
{
    class Program
    {
        static void Main(string[] args)
        {
            Func<TimeSpan, double> TimeToDegrees = (time) =>
                360 * time.Hours / 24.0 +
                360 * time.Minutes / (24 * 60.0) +
                360 * time.Seconds / (24 * 3600.0);
            Func<List<double>, double> MeanAngle = (angles) =>
                {
                    double y_part = 0.0d, x_part = 0.0d;
                    int numItems = angles.Count;

                    for (int i = 0; i < numItems; i++)
                    {
                        x_part += Math.Cos(angles[i] * Math.PI / 180);
                        y_part += Math.Sin(angles[i] * Math.PI / 180);
                    }

                    return Math.Atan2(y_part / numItems, x_part / numItems) * 180 / Math.PI;
                };
            Func<double, TimeSpan> TimeFromDegrees = (angle) =>
                    new TimeSpan(
                        (int)(24 * 60 * 60 * angle / 360) / 3600,
                        ((int)(24 * 60 * 60 * angle / 360) % 3600 - (int)(24 * 60 * 60 * angle / 360) % 60) / 60,
                        (int)(24 * 60 * 60 * angle / 360) % 60);
            List<double> digitimes = new List<double>();
            TimeSpan digitime;
            string input;

            Console.WriteLine("Enter times, end with no input: ");
            do
            {
                input = Console.ReadLine();
                if (!(string.IsNullOrWhiteSpace(input)))
                {
                    if (TimeSpan.TryParse(input, out digitime))
                        digitimes.Add(TimeToDegrees(digitime));
                    else
                        Console.WriteLine("Seems this is wrong input: ignoring time");
                }
            } while (!string.IsNullOrWhiteSpace(input));

            if(digitimes.Count() > 0)
                Console.WriteLine("The mean time is : {0}", TimeFromDegrees(360 + MeanAngle(digitimes)));
        }
    }
}
