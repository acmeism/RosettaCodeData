using System;

namespace URLEncode
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            Console.WriteLine(Decode("http%3A%2F%2Ffoo%20bar%2F"));
        }

        private static string Decode(string uri)
        {
            return Uri.UnescapeDataString(uri);
        }
    }
}
