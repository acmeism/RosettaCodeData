using System;
using System.Diagnostics;
using System.Drawing;

namespace RosettaBarnsleyFern
{
    class Program
    {
        static void Main(string[] args)
        {
            const int w = 600;
            const int h = 600;
            var bm = new Bitmap(w, h);
            var r = new Random();
            double x = 0;
            double y = 0;
            for (int count = 0; count < 100000; count++)
            {
                bm.SetPixel((int)(300 + 58 * x), (int)(58 * y), Color.ForestGreen);
                int roll = r.Next(100);
                double xp = x;
                if (roll < 1)
                {
                    x = 0;
                    y = 0.16 * y;
                } else if (roll < 86)
                {
                    x = 0.85 * x + 0.04 * y;
                    y = -0.04 * xp + 0.85 * y + 1.6;
                } else if (roll < 93)
                {
                    x = 0.2 * x - 0.26 * y;
                    y = 0.23 * xp + 0.22 * y + 1.6;
                } else
                {
                    x = -0.15 * x + 0.28 * y;
                    y = 0.26 * xp + 0.24 * y + 0.44;
                }
            }
            const string filename = "Fern.png";
            bm.Save(filename);
            Process.Start(filename);
        }
    }
}
