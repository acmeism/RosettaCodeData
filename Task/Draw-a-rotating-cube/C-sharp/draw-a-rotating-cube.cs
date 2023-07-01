using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;
using System.Windows.Threading;

namespace RotatingCube
{
    public partial class Form1 : Form
    {
        double[][] nodes = {
            new double[] {-1, -1, -1}, new double[] {-1, -1, 1}, new double[] {-1, 1, -1},
            new double[] {-1, 1, 1}, new double[] {1, -1, -1}, new double[] {1, -1, 1},
            new double[] {1, 1, -1}, new double[] {1, 1, 1} };

        int[][] edges = {
            new int[] {0, 1}, new int[] {1, 3}, new int[] {3, 2}, new int[] {2, 0}, new int[] {4, 5},
            new int[] {5, 7}, new int[] {7, 6}, new int[] {6, 4}, new int[] {0, 4}, new int[] {1, 5},
            new int[] {2, 6}, new int[] {3, 7}};

        public Form1()
        {
            Width = Height = 640;
            StartPosition = FormStartPosition.CenterScreen;
            SetStyle(
                ControlStyles.AllPaintingInWmPaint |
                ControlStyles.UserPaint |
                ControlStyles.DoubleBuffer,
                true);

            Scale(100, 100, 100);
            RotateCuboid(Math.PI / 4, Math.Atan(Math.Sqrt(2)));

            var timer = new DispatcherTimer();
            timer.Tick += (s, e) => { RotateCuboid(Math.PI / 180, 0); Refresh(); };
            timer.Interval = new TimeSpan(0, 0, 0, 0, 17);
            timer.Start();
        }

        private void RotateCuboid(double angleX, double angleY)
        {
            double sinX = Math.Sin(angleX);
            double cosX = Math.Cos(angleX);

            double sinY = Math.Sin(angleY);
            double cosY = Math.Cos(angleY);

            foreach (var node in nodes)
            {
                double x = node[0];
                double y = node[1];
                double z = node[2];

                node[0] = x * cosX - z * sinX;
                node[2] = z * cosX + x * sinX;

                z = node[2];

                node[1] = y * cosY - z * sinY;
                node[2] = z * cosY + y * sinY;
            }
        }

        private void Scale(int v1, int v2, int v3)
        {
            foreach (var item in nodes)
            {
                item[0] *= v1;
                item[1] *= v2;
                item[2] *= v3;
            }
        }

        protected override void OnPaint(PaintEventArgs args)
        {
            var g = args.Graphics;
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.Clear(Color.White);

            g.TranslateTransform(Width / 2, Height / 2);

            foreach (var edge in edges)
            {
                double[] xy1 = nodes[edge[0]];
                double[] xy2 = nodes[edge[1]];
                g.DrawLine(Pens.Black, (int)Math.Round(xy1[0]), (int)Math.Round(xy1[1]),
                        (int)Math.Round(xy2[0]), (int)Math.Round(xy2[1]));
            }

            foreach (var node in nodes)
            {
                g.FillEllipse(Brushes.Black, (int)Math.Round(node[0]) - 4,
                    (int)Math.Round(node[1]) - 4, 8, 8);
            }
        }
    }
}
