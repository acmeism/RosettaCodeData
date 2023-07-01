using System;
using System.IO;

class Program
{
    static void Main(string[] args)
    {
        // For stdin, you could use
        // new StreamReader(Console.OpenStandardInput(), Console.InputEncoding)

        using (var b = new StreamReader("file.txt"))
        {
            string line;
            while ((line = b.ReadLine()) != null)
                Console.WriteLine(line);
        }
    }
}
