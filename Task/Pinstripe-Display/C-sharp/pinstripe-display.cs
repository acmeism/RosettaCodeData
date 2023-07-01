using System.Drawing;

public class Pinstripe
{
    static void Main(string[] args)
    {
        var pinstripe = MakePinstripeImage(1366, 768);
        pinstripe.Save("pinstripe.png");
    }

    public static Bitmap MakePinstripeImage(int width, int height)
    {
        var image = new Bitmap(width, height);
        var quarterHeight = height / 4;

        for (var y = 0; y < height; y++)
        {
            var stripeWidth = (y / quarterHeight) + 1;

            for (var x = 0; x < width; x++)
            {
                var color = ((x / stripeWidth) % 2) == 0 ? Color.White : Color.Black;
                image.SetPixel(x, y, color);
            }
        }

        return image;
    }
}
