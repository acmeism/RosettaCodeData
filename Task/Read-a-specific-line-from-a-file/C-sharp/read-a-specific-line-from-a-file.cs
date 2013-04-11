using System;
using System.IO;

namespace GetLine
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            Console.WriteLine(GetLine(args[0], uint.Parse(args[1])));
        }

        private static string GetLine(string path, uint line)
        {
            using (var reader = new StreamReader(path))
            {
                try
                {
                    for (uint i = 0; i <= line; i++)
                    {
                        if (reader.EndOfStream)
                            return string.Format("There {1} less than {0} line{2} in the file.", line,
                                                 ((line == 1) ? "is" : "are"), ((line == 1) ? "" : "s"));

                        if (i == line)
                            return reader.ReadLine();

                        reader.ReadLine();
                    }
                }
                catch (IOException ex)
                {
                    return ex.Message;
                }
                catch (OutOfMemoryException ex)
                {
                    return ex.Message;
                }
            }

            throw new Exception("Something bad happened.");
        }
    }
}
