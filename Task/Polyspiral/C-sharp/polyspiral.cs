using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;
using System.Windows.Threading;

namespace Polyspiral
{
    public partial class Form1 : Form
    {
        private double inc;

        public Form1()
        {
            Width = Height = 640;
            StartPosition = FormStartPosition.CenterScreen;
            SetStyle(
                ControlStyles.AllPaintingInWmPaint |
                ControlStyles.UserPaint |
                ControlStyles.DoubleBuffer,
                true);

            var timer = new DispatcherTimer();
            timer.Tick += (s, e) => { inc = (inc + 0.05) % 360; Refresh(); };
            timer.Interval = new TimeSpan(0, 0, 0, 0, 40);
            timer.Start();
        }

        private void DrawSpiral(Graphics g, int len, double angleIncrement)
        {
            double x1 = Width / 2;
            double y1 = Height / 2;
            double angle = angleIncrement;

            for (int i = 0; i < 150; i++)
            {
                double x2 = x1 + Math.Cos(angle) * len;
                double y2 = y1 - Math.Sin(angle) * len;
                g.DrawLine(Pens.Blue, (int)x1, (int)y1, (int)x2, (int)y2);
                x1 = x2;
                y1 = y2;

                len += 3;

                angle = (angle + angleIncrement) % (Math.PI * 2);
            }
        }

        protected override void OnPaint(PaintEventArgs args)
        {
            var g = args.Graphics;
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.White);

            DrawSpiral(g, 5, ToRadians(inc));
        }

        private double ToRadians(double angle)
        {
            return Math.PI * angle / 180.0;
        }
    }
}
