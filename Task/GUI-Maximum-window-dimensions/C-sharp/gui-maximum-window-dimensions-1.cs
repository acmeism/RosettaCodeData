using System;
using System.Drawing;
using System.Windows.Forms;

static class Program
{
    static void Main()
    {
        Rectangle bounds = Screen.PrimaryScreen.Bounds;
        Console.WriteLine($"Primary screen bounds:  {bounds.Width}x{bounds.Height}");

        Rectangle workingArea = Screen.PrimaryScreen.WorkingArea;
        Console.WriteLine($"Primary screen working area:  {workingArea.Width}x{workingArea.Height}");
    }
}
