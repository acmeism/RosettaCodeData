using System;
using System.IO;
using System.Text;

namespace RosettaFileByChar
{
    class Program
    {
        static char GetNextCharacter(StreamReader streamReader) => (char)streamReader.Read();

        static void Main(string[] args)
        {
            Console.OutputEncoding = Encoding.UTF8;
            char c;
            using (FileStream fs = File.OpenRead("input.txt"))
            {
                using (StreamReader streamReader = new StreamReader(fs, Encoding.UTF8))
                {
                    while (!streamReader.EndOfStream)
                    {
                        c = GetNextCharacter(streamReader);
                        Console.Write(c);
                    }
                }
            }
        }
    }
}
