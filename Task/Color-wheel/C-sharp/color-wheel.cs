// constructor of main window
// in MainWindow.xaml just create <Image Name="imgMain" />
public MainWindow()
{
    InitializeComponent();
    RenderOptions.SetBitmapScalingMode(imgMain, BitmapScalingMode.HighQuality);
    imgMain.Source = new WriteableBitmap(480, 480, 96, 96, PixelFormats.Bgr32, null);
    // using slider you can change saturation and call DrawHue with different level
    DrawHue(100);
}

void DrawHue(int saturation)
{
    var bmp = (WriteableBitmap)imgMain.Source;

    int centerX = (int)bmp.Width / 2;
    int centerY = (int)bmp.Height / 2;
    int radius = Math.Min(centerX, centerY);
    int radius2 = radius - 40;

    bmp.Lock();
    unsafe{
        var buf = bmp.BackBuffer;
        IntPtr pixLineStart;
        for(int y=0; y < bmp.Height; y++){
            pixLineStart = buf + bmp.BackBufferStride * y;
            double dy = (y - centerY);
            for(int x=0; x < bmp.Width; x++){
                double dx = (x - centerX);
                double dist = Math.Sqrt(dx * dx + dy * dy);
                if (radius2 <= dist && dist <= radius) {
                    double theta = Math.Atan2(dy, dx);
                    double hue = (theta + Math.PI) / (2.0 * Math.PI);
                    *((int*)(pixLineStart + x * 4)) = HSB_to_RGB((int)(hue * 360), saturation, 100);
                }
            }
        }
    }
    bmp.AddDirtyRect(new Int32Rect(0, 0, 480, 480));
    bmp.Unlock();
}

static int HSB_to_RGB(int h, int s, int v)
{
    var rgb = new int[3];

    var baseColor = (h + 60) % 360 / 120;
    var shift = (h + 60) % 360 - (120 * baseColor + 60 );
    var secondaryColor = (baseColor + (shift >= 0 ? 1 : -1) + 3) % 3;

    //Setting Hue
    rgb[baseColor] = 255;
    rgb[secondaryColor] = (int) ((Math.Abs(shift) / 60.0f) * 255.0f);

    //Setting Saturation
    for (var i = 0; i < 3; i++)
        rgb[i] += (int) ((255 - rgb[i]) * ((100 - s) / 100.0f));

    //Setting Value
    for (var i = 0; i < 3; i++)
        rgb[i] -= (int) (rgb[i] * (100-v) / 100.0f);

    return RGB2int(rgb[0], rgb[1], rgb[2]);
}

public static int RGB2int(int r, int g, int b) => r << 16 | g << 8 | b;
