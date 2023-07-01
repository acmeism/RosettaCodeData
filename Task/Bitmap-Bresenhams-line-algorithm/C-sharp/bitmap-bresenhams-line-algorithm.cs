using System;
using System.Drawing;
using System.Drawing.Imaging;
static class Program
{
    static void Main()
    {
        new Bitmap(200, 200)
            .DrawLine(0, 0, 199, 199, Color.Black).DrawLine(199,0,0,199,Color.Black)
            .DrawLine(50, 75, 150, 125, Color.Blue).DrawLine(150, 75, 50, 125, Color.Blue)
            .Save("line.png", ImageFormat.Png);
    }
    static Bitmap DrawLine(this Bitmap bitmap, int x0, int y0, int x1, int y1, Color color)
    {
        int dx = Math.Abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
        int dy = Math.Abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
        int err = (dx > dy ? dx : -dy) / 2, e2;
        for(;;) {
            bitmap.SetPixel(x0, y0, color);
            if (x0 == x1 && y0 == y1) break;
            e2 = err;
            if (e2 > -dx) { err -= dy; x0 += sx; }
            if (e2 < dy) { err += dx; y0 += sy; }
        }
        return bitmap;
    }
}
