namespace RosettaCode.Base64EncodeData
{
    using System;
    using System.Net;

    internal static class Program
    {
        private static void Main()
        {
            const string path = "http://rosettacode.org/favicon.ico";

            byte[] input;
            using (var client = new WebClient())
            {
                input = client.DownloadData(path);
            }

            var output = Convert.ToBase64String(input);
            Console.WriteLine(output);
        }
    }
}
