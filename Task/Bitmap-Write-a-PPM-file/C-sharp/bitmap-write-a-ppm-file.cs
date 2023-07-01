using System;
using System.IO;
class PPMWriter
{
    public static void WriteBitmapToPPM(string file, Bitmap bitmap)
        {
            //Use a streamwriter to write the text part of the encoding
            var writer = new StreamWriter(file);
            writer.WriteLine("P6");
            writer.WriteLine($"{bitmap.Width}  {bitmap.Height}");
            writer.WriteLine("255");
            writer.Close();
            //Switch to a binary writer to write the data
            var writerB = new BinaryWriter(new FileStream(file, FileMode.Append));
            for (int x = 0; x < bitmap.Height; x++)
                for (int y = 0; y < bitmap.Width; y++)
                {
                    Color color = bitmap.GetPixel(y, x);
                    writerB.Write(color.R);
                    writerB.Write(color.G);
                    writerB.Write(color.B);
                }
            writerB.Close();
        }
}
