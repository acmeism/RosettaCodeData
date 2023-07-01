using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows.Forms;

class Program
{
    static Size size = new Size(320, 240);
    static Rectangle rectsize = new Rectangle(new Point(0, 0), size);
    static int numpixels = size.Width * size.Height;
    static int numbytes = numpixels * 3;

    static PictureBox pb;
    static BackgroundWorker worker;

    static double time = 0;
    static double frames = 0;
    static Random rand = new Random();

    static byte tmp;
    static byte white = 255;
    static byte black = 0;
    static int halfmax = int.MaxValue / 2; // more voodoo! calling Next() is faster than Next(2)!

    static IEnumerable<byte> YieldVodoo()
    {
        // Yield 3 times same number (i.e 255 255 255) for numpixels times.

        for (int i = 0; i < numpixels; i++)
        {
            tmp = rand.Next() < halfmax ? black : white; // no more lists!

            // no more loops! yield! yield! yield!
            yield return tmp;
            yield return tmp;
            yield return tmp;
        }
    }

    static Image Randimg()
    {
        // Low-level bitmaps
        var bitmap = new Bitmap(size.Width, size.Height);
        var data = bitmap.LockBits(rectsize, ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

        Marshal.Copy(
            YieldVodoo().ToArray<byte>(),// source
            0, // start
            data.Scan0, // scan0 is a pointer to low-level bitmap data
            numbytes); // number of bytes in source

        bitmap.UnlockBits(data);
        return bitmap;
    }

    [STAThread]
    static void Main()
    {
        var form = new Form();

        form.AutoSize = true;
        form.Size = new Size(0, 0);
        form.Text = "Test";

        form.FormClosed += delegate
        {
            Application.Exit();
        };

        worker = new BackgroundWorker();

        worker.DoWork += delegate
        {
            System.Threading.Thread.Sleep(500); // remove try/catch, just wait a bit before looping

            while (true)
            {
                var a = DateTime.Now;
                pb.Image = Randimg();
                var b = DateTime.Now;

                time += (b - a).TotalSeconds;
                frames += 1;

                if (frames == 30)
                {
                    Console.WriteLine("{0} frames in {1:0.000} seconds. ({2:0} FPS)", frames, time, frames / time);

                    time = 0;
                    frames = 0;
                }
            }
        };

        worker.RunWorkerAsync();

        FlowLayoutPanel flp = new FlowLayoutPanel();
        form.Controls.Add(flp);

        pb = new PictureBox();
        pb.Size = size;

        flp.AutoSize = true;
        flp.Controls.Add(pb);

        form.Show();
        Application.Run();
    }
}
