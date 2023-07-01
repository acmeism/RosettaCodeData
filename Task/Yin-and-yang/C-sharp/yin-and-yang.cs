    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Paint += Form1_Paint;
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            DrawTaijitu(g, new Point(50, 50), 200, true);
            DrawTaijitu(g, new Point(10, 10), 60, true);
        }

        private void DrawTaijitu(Graphics g, Point pt, int width, bool hasOutline)
        {
            g.FillPie(Brushes.Black, pt.X, pt.Y, width, width, 90, 180);
            g.FillPie(Brushes.White, pt.X, pt.Y, width, width, 270, 180);
            float headSize = Convert.ToSingle(width * 0.5);
            float headXPosition = Convert.ToSingle(pt.X + (width * 0.25));
            g.FillEllipse(Brushes.Black, headXPosition, Convert.ToSingle(pt.Y), headSize, headSize);
            g.FillEllipse(Brushes.White, headXPosition, Convert.ToSingle(pt.Y + (width * 0.5)), headSize, headSize);
            float headBlobSize = Convert.ToSingle(width * 0.125);
            float headBlobXPosition = Convert.ToSingle(pt.X + (width * 0.4375));
            g.FillEllipse(Brushes.White, headBlobXPosition, Convert.ToSingle(pt.Y + (width * 0.1875)), headBlobSize, headBlobSize);
            g.FillEllipse(Brushes.Black, headBlobXPosition, Convert.ToSingle(pt.Y + (width * 0.6875)), headBlobSize, headBlobSize);
            if (hasOutline) g.DrawEllipse(Pens.Black, pt.X, pt.Y, width, width);
        }
    }
