using System;
using System.Text;
using System.Net;

class Program
{
    static void Main(string[] args)
    {
        WebClient wc = new WebClient();
        string content = wc.DownloadString("http://www.google.com");
        Console.WriteLine(content);
    }
}
