using System;
using System.Diagnostics;
using System.Drawing;

namespace RosettaConstrainedRandomCircle
{
    class Program
    {
        static void Main(string[] args)
        {
            var points = new Point[404];
            int i = 0;
            for (int y = -15; y <= 15; y++)
                for (int x = -15; x <= 15 && i < 404; x++)
                {
                    var c = Math.Sqrt(x * x + y * y);
                    if (10 <= c && c <= 15)
                    {
                        points[i++] = new Point(x, y);
                    }
                }

            var bm = new Bitmap(600, 600);
            var g = Graphics.FromImage(bm);
            var brush = new SolidBrush(Color.Magenta);

            var r = new System.Random();
            for (int count = 0; count < 100; count++)
            {
                var p = points[r.Next(404)];
                g.FillEllipse(brush, new Rectangle(290 + 19 * p.X, 290 + 19 * p.Y, 10, 10));
            }
            const string filename = "Constrained Random Circle.png";
            bm.Save(filename);
            Process.Start(filename);
        }
    }
}
