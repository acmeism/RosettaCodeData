using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

public class Clock : Form
{
    static readonly float degrees06 = (float)Math.PI / 30;
    static readonly float degrees30 = degrees06 * 5;
    static readonly float degrees90 = degrees30 * 3;

    readonly int margin = 20;

    private Point p0;

    public Clock()
    {
        Size = new Size(500, 500);
        StartPosition = FormStartPosition.CenterScreen;
        Resize += (sender, args) => ResetSize();
        ResetSize();
        var timer = new Timer() { Interval = 1000, Enabled = true };
        timer.Tick += (sender, e) => Refresh();
        DoubleBuffered = true;
    }

    private void ResetSize()
    {
        p0 = new Point(ClientRectangle.Width / 2, ClientRectangle.Height / 2);
        Refresh();
    }

    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);
        e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;

        drawFace(e.Graphics);

        var time = DateTime.Now;
        int second = time.Second;
        int minute = time.Minute;
        int hour = time.Hour;

        float angle = degrees90 - (degrees06 * second);
        DrawHand(e.Graphics, Pens.Red, angle, 0.95);

        float minsecs = (minute + second / 60.0F);
        angle = degrees90 - (degrees06 * minsecs);
        DrawHand(e.Graphics, Pens.Black, angle, 0.9);

        float hourmins = (hour + minsecs / 60.0F);
        angle = degrees90 - (degrees30 * hourmins);
        DrawHand(e.Graphics, Pens.Black, angle, 0.6);
    }

    private void drawFace(Graphics g)
    {
        int radius = Math.Min(p0.X, p0.Y) - margin;
        g.FillEllipse(Brushes.White, p0.X - radius, p0.Y - radius, radius * 2, radius * 2);

        for (int h = 0; h < 12; h++)
            DrawHand(g, Pens.LightGray, h * degrees30, -0.05);

        for (int m = 0; m < 60; m++)
            DrawHand(g, Pens.LightGray, m * degrees06, -0.025);
    }

    private void DrawHand(Graphics g, Pen pen, float angle, double size)
    {
        int radius = Math.Min(p0.X, p0.Y) - margin;

        int x0 = p0.X + (size > 0 ? 0 : Convert.ToInt32(radius * (1 + size) * Math.Cos(angle)));
        int y0 = p0.Y + (size > 0 ? 0 : Convert.ToInt32(radius * (1 + size) * Math.Sin(-angle)));

        int x1 = p0.X + Convert.ToInt32(radius * (size > 0 ? size : 1) * Math.Cos(angle));
        int y1 = p0.Y + Convert.ToInt32(radius * (size > 0 ? size : 1) * Math.Sin(-angle));

        g.DrawLine(pen, x0, y0, x1, y1);
    }

    [STAThread]
    static void Main()
    {
        Application.Run(new Clock());
    }
}
