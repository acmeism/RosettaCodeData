using System;
using System.Net;

class Program
{
    class MyWebClient : WebClient
    {
        protected override WebRequest GetWebRequest(Uri address)
        {
            HttpWebRequest request = (HttpWebRequest)base.GetWebRequest(address);
            request.ClientCertificates.Add(new X509Certificate());
            return request;
        }
    }
    static void Main(string[] args)
    {
        var client = new MyWebClient();

        var data = client.DownloadString("https://example.com");

        Console.WriteLine(data);
    }
}
