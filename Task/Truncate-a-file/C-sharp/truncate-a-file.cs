using System;
using System.IO;

namespace TruncateFile
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            TruncateFile(args[0], long.Parse(args[1]));
        }

        private static void TruncateFile(string path, long length)
        {
            if (!File.Exists(path))
                throw new ArgumentException("No file found at specified path.", "path");

            using (var fileStream = new FileStream(path, FileMode.Open, FileAccess.Write))
            {
                if (fileStream.Length < length)
                    throw new ArgumentOutOfRangeException("length",
                                                          "The specified length is greater than that of the file.");

                fileStream.SetLength(length);
            }
        }
    }
}
