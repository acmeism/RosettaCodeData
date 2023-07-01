using System;
using System.Windows.Forms;
static class Program
{
    [STAThread]
    static void Main()
    {
        Console.WriteLine(Control.MousePosition.X);
        Console.WriteLine(Control.MousePosition.Y);
    }
}
