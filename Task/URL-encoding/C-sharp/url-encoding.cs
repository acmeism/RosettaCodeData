using System;

namespace URLEncode
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            Console.WriteLine(Encode("http://foo bar/"));
        }

        private static string Encode(string uri)
        {
            return Uri.EscapeDataString(uri);
        }
    }
}
