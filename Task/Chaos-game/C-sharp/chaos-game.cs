using System.Diagnostics;
using System.Drawing;

namespace RosettaChaosGame
{
    class Program
    {
        static void Main(string[] args)
        {
            var bm = new Bitmap(600, 600);

            var referencePoints = new Point[] {
                new Point(0, 600),
                new Point(600, 600),
                new Point(300, 81)
            };
            var r = new System.Random();
            var p = new Point(r.Next(600), r.Next(600));
            for (int count = 0; count < 10000; count++)
            {
                bm.SetPixel(p.X, p.Y, Color.Magenta);
                int i = r.Next(3);
                p.X = (p.X + referencePoints[i].X) / 2;
                p.Y = (p.Y + referencePoints[i].Y) / 2;
            }
            const string filename = "Chaos Game.png";
            bm.Save(filename);
            Process.Start(filename);
        }
    }
}
