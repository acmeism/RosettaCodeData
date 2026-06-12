using System;
using System.Drawing;

namespace BilinearInterpolation {
    class Program {
        private static float Lerp(float s, float e, float t) {
            return s + (e - s) * t;
        }

        private static float Blerp(float c00, float c10, float c01, float c11, float tx, float ty) {
            return Lerp(Lerp(c00, c10, tx), Lerp(c01, c11, tx), ty);
        }

        private static Image Scale(Bitmap self, float scaleX, float scaleY) {
            int newWidth = (int)(self.Width * scaleX);
            int newHeight = (int)(self.Height * scaleY);
            Bitmap newImage = new Bitmap(newWidth, newHeight, self.PixelFormat);

            for (int x = 0; x < newWidth; x++) {
                for (int y = 0; y < newHeight; y++) {
                    float gx = ((float)x) / newWidth * (self.Width - 1);
                    float gy = ((float)y) / newHeight * (self.Height - 1);
                    int gxi = (int)gx;
                    int gyi = (int)gy;
                    Color c00 = self.GetPixel(gxi, gyi);
                    Color c10 = self.GetPixel(gxi + 1, gyi);
                    Color c01 = self.GetPixel(gxi, gyi + 1);
                    Color c11 = self.GetPixel(gxi + 1, gyi + 1);

                    int red = (int)Blerp(c00.R, c10.R, c01.R, c11.R, gx - gxi, gy - gyi);
                    int green = (int)Blerp(c00.G, c10.G, c01.G, c11.G, gx - gxi, gy - gyi);
                    int blue = (int)Blerp(c00.B, c10.B, c01.B, c11.B, gx - gxi, gy - gyi);
                    Color rgb = Color.FromArgb(red, green, blue);
                    newImage.SetPixel(x, y, rgb);
                }
            }

            return newImage;
        }

        static void Main(string[] args) {
            Image newImage = Image.FromFile("Lenna100.jpg");
            if (newImage is Bitmap oi) {
                Image result = Scale(oi, 1.6f, 1.6f);
                result.Save("Lenna100_larger.jpg");
            } else {
                Console.WriteLine("Could not open the source file.");
            }
        }
    }
}
