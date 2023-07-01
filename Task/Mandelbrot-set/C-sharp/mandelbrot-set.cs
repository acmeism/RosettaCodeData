using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Threading;
using System.Windows.Forms;

/// <summary>
/// Generates bitmap of Mandelbrot Set and display it on the form.
/// </summary>
public class MandelbrotSetForm : Form
{
    const double MaxValueExtent = 2.0;
    Thread thread;

    static double CalcMandelbrotSetColor(ComplexNumber c)
    {
        // from http://en.wikipedia.org/w/index.php?title=Mandelbrot_set
        const int MaxIterations = 1000;
        const double MaxNorm = MaxValueExtent * MaxValueExtent;

        int iteration = 0;
        ComplexNumber z = new ComplexNumber();
        do
        {
            z = z * z + c;
            iteration++;
        } while (z.Norm() < MaxNorm && iteration < MaxIterations);
        if (iteration < MaxIterations)
            return (double)iteration / MaxIterations;
        else
            return 0; // black
    }

    static void GenerateBitmap(Bitmap bitmap)
    {
        double scale = 2 * MaxValueExtent / Math.Min(bitmap.Width, bitmap.Height);
        for (int i = 0; i < bitmap.Height; i++)
        {
            double y = (bitmap.Height / 2 - i) * scale;
            for (int j = 0; j < bitmap.Width; j++)
            {
                double x = (j - bitmap.Width / 2) * scale;
                double color = CalcMandelbrotSetColor(new ComplexNumber(x, y));
                bitmap.SetPixel(j, i, GetColor(color));
            }
        }
    }

    static Color GetColor(double value)
    {
        const double MaxColor = 256;
        const double ContrastValue = 0.2;
        return Color.FromArgb(0, 0,
            (int)(MaxColor * Math.Pow(value, ContrastValue)));
    }

    public MandelbrotSetForm()
    {
        // form creation
        this.Text = "Mandelbrot Set Drawing";
        this.BackColor = System.Drawing.Color.Black;
        this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
        this.MaximizeBox = false;
        this.StartPosition = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.FixedDialog;
        this.ClientSize = new Size(640, 640);
        this.Load += new System.EventHandler(this.MainForm_Load);
    }

    void MainForm_Load(object sender, EventArgs e)
    {
        thread = new Thread(thread_Proc);
        thread.IsBackground = true;
        thread.Start(this.ClientSize);
    }

    void thread_Proc(object args)
    {
        // start from small image to provide instant display for user
        Size size = (Size)args;
        int width = 16;
        while (width * 2 < size.Width)
        {
            int height = width * size.Height / size.Width;
            Bitmap bitmap = new Bitmap(width, height, PixelFormat.Format24bppRgb);
            GenerateBitmap(bitmap);
            this.BeginInvoke(new SetNewBitmapDelegate(SetNewBitmap), bitmap);
            width *= 2;
            Thread.Sleep(200);
        }
        // then generate final image
        Bitmap finalBitmap = new Bitmap(size.Width, size.Height, PixelFormat.Format24bppRgb);
        GenerateBitmap(finalBitmap);
        this.BeginInvoke(new SetNewBitmapDelegate(SetNewBitmap), finalBitmap);
    }

    void SetNewBitmap(Bitmap image)
    {
        if (this.BackgroundImage != null)
            this.BackgroundImage.Dispose();
        this.BackgroundImage = image;
    }

    delegate void SetNewBitmapDelegate(Bitmap image);

    static void Main()
    {
        Application.Run(new MandelbrotSetForm());
    }
}

struct ComplexNumber
{
    public double Re;
    public double Im;

    public ComplexNumber(double re, double im)
    {
        this.Re = re;
        this.Im = im;
    }

    public static ComplexNumber operator +(ComplexNumber x, ComplexNumber y)
    {
        return new ComplexNumber(x.Re + y.Re, x.Im + y.Im);
    }

    public static ComplexNumber operator *(ComplexNumber x, ComplexNumber y)
    {
        return new ComplexNumber(x.Re * y.Re - x.Im * y.Im,
            x.Re * y.Im + x.Im * y.Re);
    }

    public double Norm()
    {
        return Re * Re + Im * Im;
    }
}
