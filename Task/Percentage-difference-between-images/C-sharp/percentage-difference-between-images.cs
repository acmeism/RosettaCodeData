using System;
using System.Drawing;

class Program
{
    static void Main()
    {
        Bitmap img1 = new Bitmap("Lenna50.jpg");
        Bitmap img2 = new Bitmap("Lenna100.jpg");

        if (img1.Size != img2.Size)
        {
            Console.Error.WriteLine("Images are of different sizes");
            return;
        }

        float diff = 0;

        for (int y = 0; y < img1.Height; y++)
        {
            for (int x = 0; x < img1.Width; x++)
            {
                Color pixel1 = img1.GetPixel(x, y);
                Color pixel2 = img2.GetPixel(x, y);

                diff += Math.Abs(pixel1.R - pixel2.R);
                diff += Math.Abs(pixel1.G - pixel2.G);
                diff += Math.Abs(pixel1.B - pixel2.B);
            }
        }

        Console.WriteLine("diff: {0} %", 100 * (diff / 255) / (img1.Width * img1.Height * 3));
    }
}
