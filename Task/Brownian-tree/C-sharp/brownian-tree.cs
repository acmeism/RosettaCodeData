using System;
using System.Drawing;

namespace BrownianTree
{
    class Program
    {
        static Bitmap BrownianTree(int size, int numparticles)
        {
            Bitmap bmp = new Bitmap(size, size);
            Rectangle bounds = new Rectangle { X = 0, Y = 0, Size = bmp.Size };
            using (Graphics g = Graphics.FromImage(bmp))
            {
                g.Clear(Color.Black);
            }
            Random rnd = new Random();
            bmp.SetPixel(rnd.Next(size), rnd.Next(size), Color.White);
            Point pt = new Point(), newpt = new Point();
            for (int i = 0; i < numparticles; i++)
            {
                pt.X = rnd.Next(size);
                pt.Y = rnd.Next(size);
                do
                {
                    newpt.X = pt.X + rnd.Next(-1, 2);
                    newpt.Y = pt.Y + rnd.Next(-1, 2);
                    if (!bounds.Contains(newpt))
                    {
                        pt.X = rnd.Next(size);
                        pt.Y = rnd.Next(size);
                    }
                    else if (bmp.GetPixel(newpt.X, newpt.Y).R > 0)
                    {
                        bmp.SetPixel(pt.X, pt.Y, Color.White);
                        break;
                    }
                    else
                    {
                        pt = newpt;
                    }
                } while (true);
            }
            return bmp;
        }

        static void Main(string[] args)
        {
            BrownianTree(300, 3000).Save("browniantree.png");
        }
    }
}
