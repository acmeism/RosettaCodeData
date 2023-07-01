using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;

class XORPattern
{
    static void Main()
    {
        var size = 0x100;
        var black = Color.Black.ToArgb();
        var palette = Enumerable.Range(black, size).Select(Color.FromArgb).ToArray();
        using (var image = new Bitmap(size, size))
        {
            for (var x = 0; x < size; x++)
            {
                for (var y = 0; y < size; y++)
                {
                    image.SetPixel(x, y, palette[x ^ y]);
                }
            }
            image.Save("XORPatternCSharp.png", ImageFormat.Png);
        }
    }
}
