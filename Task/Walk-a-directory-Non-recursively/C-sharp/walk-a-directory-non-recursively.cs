using System;
using System.IO;

namespace DirectoryWalk
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] filePaths = Directory.GetFiles(@"c:\MyDir", "a*");
            foreach (string filename in filePaths)
                Console.WriteLine(filename);
        }
    }
}
