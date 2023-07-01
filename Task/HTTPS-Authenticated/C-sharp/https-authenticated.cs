using System;
using System.Net;

class Program
{
    static void Main(string[] args)
    {
        var client = new WebClient();

        // credentials of current user:
        client.Credentials = CredentialCache.DefaultCredentials;
        // or specify credentials manually:
        client.Credentials = new NetworkCredential("User", "Password");

        var data = client.DownloadString("https://example.com");

        Console.WriteLine(data);
    }
}
