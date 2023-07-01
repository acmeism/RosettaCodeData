using System;
using System.Net;

class Program
{
    static void Main(string[] args)
    {
        var client = new WebClient();
        var data = client.DownloadString("https://www.google.com");

        Console.WriteLine(data);
    }
}
