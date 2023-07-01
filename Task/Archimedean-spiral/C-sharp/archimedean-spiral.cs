using System;
using System.Linq;
using System.Drawing;
using System.Diagnostics;
using System.Drawing.Drawing2D;

class Program
{
    const int width = 380;
    const int height = 380;
    static PointF archimedeanPoint(int degrees)
    {
        const double a = 1;
        const double b = 9;
        double t = degrees * Math.PI / 180;
        double r = a + b * t;
        return new PointF { X = (float)(width / 2 + r * Math.Cos(t)), Y = (float)(height / 2 + r * Math.Sin(t)) };
    }

    static void Main(string[] args)
    {
        var bm = new Bitmap(width, height);
        var g = Graphics.FromImage(bm);
        g.SmoothingMode = SmoothingMode.AntiAlias;
        g.FillRectangle(new SolidBrush(Color.White), new Rectangle { X = 0, Y = 0, Width = width, Height = height });
        var pen = new Pen(Color.OrangeRed, 1.5f);

        var spiral = Enumerable.Range(0, 360 * 3).AsParallel().AsOrdered().Select(archimedeanPoint);
        var p0 = new PointF(width / 2, height / 2);
        foreach (var p1 in spiral)
        {
            g.DrawLine(pen, p0, p1);
            p0 = p1;
        }
        g.Save(); // is this really necessary ?
        bm.Save("archimedes-csharp.png");
        Process.Start("archimedes-csharp.png"); // Launches default photo viewing app
    }
}
