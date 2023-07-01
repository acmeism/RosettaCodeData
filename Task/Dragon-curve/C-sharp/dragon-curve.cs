using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

public class DragonCurve : Form
{
    private List<int> turns;
    private double startingAngle, side;

    public DragonCurve(int iter)
    {
        Size = new Size(800, 600);
        StartPosition = FormStartPosition.CenterScreen;
        DoubleBuffered = true;
        BackColor = Color.White;

        startingAngle = -iter * (Math.PI / 4);
        side = 400 / Math.Pow(2, iter / 2.0);

        turns = getSequence(iter);
    }

    private List<int> getSequence(int iter)
    {
        var turnSequence = new List<int>();
        for (int i = 0; i < iter; i++)
        {
            var copy = new List<int>(turnSequence);
            copy.Reverse();
            turnSequence.Add(1);
            foreach (int turn in copy)
            {
                turnSequence.Add(-turn);
            }
        }
        return turnSequence;
    }

    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);
        e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;

        double angle = startingAngle;
        int x1 = 230, y1 = 350;
        int x2 = x1 + (int)(Math.Cos(angle) * side);
        int y2 = y1 + (int)(Math.Sin(angle) * side);
        e.Graphics.DrawLine(Pens.Black, x1, y1, x2, y2);
        x1 = x2;
        y1 = y2;
        foreach (int turn in turns)
        {
            angle += turn * (Math.PI / 2);
            x2 = x1 + (int)(Math.Cos(angle) * side);
            y2 = y1 + (int)(Math.Sin(angle) * side);
            e.Graphics.DrawLine(Pens.Black, x1, y1, x2, y2);
            x1 = x2;
            y1 = y2;
        }
    }

    [STAThread]
    static void Main()
    {
        Application.Run(new DragonCurve(14));
    }
}
