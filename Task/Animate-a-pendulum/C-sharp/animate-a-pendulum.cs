using System;
using System.Drawing;
using System.Windows.Forms;

class CSharpPendulum
{
    Form _form;
    Timer _timer;

    double _angle = Math.PI / 2,
           _angleAccel,
           _angleVelocity = 0,
           _dt = 0.1;

    int _length = 50;

    [STAThread]
    static void Main()
    {
        var p = new CSharpPendulum();
    }

    public CSharpPendulum()
    {
        _form = new Form() { Text = "Pendulum", Width = 200, Height = 200 };
        _timer = new Timer() { Interval = 30 };

        _timer.Tick += delegate(object sender, EventArgs e)
        {
            int anchorX = (_form.Width / 2) - 12,
                anchorY = _form.Height / 4,
                ballX = anchorX + (int)(Math.Sin(_angle) * _length),
                ballY = anchorY + (int)(Math.Cos(_angle) * _length);

            _angleAccel = -9.81 / _length * Math.Sin(_angle);
            _angleVelocity += _angleAccel * _dt;
            _angle += _angleVelocity * _dt;

            Bitmap dblBuffer = new Bitmap(_form.Width, _form.Height);
            Graphics g = Graphics.FromImage(dblBuffer);
            Graphics f = Graphics.FromHwnd(_form.Handle);

            g.DrawLine(Pens.Black, new Point(anchorX, anchorY), new Point(ballX, ballY));
            g.FillEllipse(Brushes.Black, anchorX - 3, anchorY - 4, 7, 7);
            g.FillEllipse(Brushes.DarkGoldenrod, ballX - 7, ballY - 7, 14, 14);

            f.Clear(Color.White);
            f.DrawImage(dblBuffer, new Point(0, 0));
        };

        _timer.Start();
        Application.Run(_form);
    }
}
