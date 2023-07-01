using System;
using System.Drawing;
using System.Windows.Forms;

static class Program
{
    static void Main()
    {
        using (var f = new Form() { FormBorderStyle = FormBorderStyle.None, WindowState = FormWindowState.Maximized })
        {
            f.Show();
            Console.WriteLine($"Size of maximized borderless form:  {f.Width}x{f.Height}");
        }
    }
}
