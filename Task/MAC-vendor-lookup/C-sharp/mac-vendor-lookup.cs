using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

class Program
{
    static async Task<string> LookupMac(string MacAddress)
    {
        var uri = new Uri("http://api.macvendors.com/" + WebUtility.UrlEncode(MacAddress));
        using (var wc = new HttpClient())
            return await wc.GetStringAsync(uri);
    }
    static void Main(string[] args)
    {
        foreach (var mac in new string[] { "88:53:2E:67:07:BE", "FC:FB:FB:01:FA:21", "D4:F4:6F:C9:EF:8D" })
            Console.WriteLine(mac + "\t" + LookupMac(mac).Result);
        Console.ReadLine();
    }
}
