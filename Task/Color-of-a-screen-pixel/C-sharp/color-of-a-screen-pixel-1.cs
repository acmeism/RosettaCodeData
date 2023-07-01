using System;
using System.Drawing;
using System.Windows.Forms;

class Program
{
    static Color GetPixel(Point position)
    {
        using (var bitmap = new Bitmap(1, 1))
        {
            using (var graphics = Graphics.FromImage(bitmap))
            {
                graphics.CopyFromScreen(position, new Point(0, 0), new Size(1, 1));
            }
            return bitmap.GetPixel(0, 0);
        }
    }

    static void Main()
    {
        Console.WriteLine(GetPixel(Cursor.Position));
    }
}
