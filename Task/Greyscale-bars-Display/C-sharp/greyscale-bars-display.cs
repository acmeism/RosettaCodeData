using System;
using System.Drawing;
using System.Windows.Forms;
static class Program { static void Main() { Application.Run(new FullScreen()); } }
public sealed class FullScreen : Form
{
    const int ColorCount = 256;
    public FullScreen()
    {
        FormBorderStyle = FormBorderStyle.None;
        WindowState = FormWindowState.Maximized;
        KeyPress += (s, e) => Application.Exit();
        BackgroundImage = ColorBars(Screen.FromControl(this).Bounds);
    }
    private static Bitmap ColorBars(Rectangle size)
    {
        var colorBars = new Bitmap(size.Width, size.Height);
        Func<int, int, int> forwardColor = (x, divs) => (int)(x * ((float)divs / size.Width)) * ColorCount / divs;
        Func<int, int, int> reverseColor = (x, divs) => ColorCount - 1 - forwardColor(x, divs);
        Action<int, int, int> setGray = (x, y, gray) => colorBars.SetPixel(x, y, Color.FromArgb(gray, gray, gray));
        Action<int, int, int> setForward = (x, y, divs) => setGray(x, y, forwardColor(x, divs));
        Action<int, int, int> setReverse = (x, y, divs) => setGray(x, y, reverseColor(x, divs));
        int verticalStripe = size.Height / 4;
        for (int x = 0; x < size.Width; x++)
        {
            for (int y = 0; y < verticalStripe; y++) setForward(x, y, 8);
            for (int y = verticalStripe; y < verticalStripe * 2; y++) setReverse(x, y, 16);
            for (int y = verticalStripe * 2; y < verticalStripe * 3; y++) setForward(x, y, 32);
            for (int y = verticalStripe * 3; y < verticalStripe * 4; y++) setReverse(x, y, 64);
        }
        return colorBars;
    }
}
