using System;
using System.Text.RegularExpressions;
using System.Text;

class ParseIPAddress
{
    private static readonly Regex IPV4_PAT = new Regex(@"^(\d+)\.(\d+)\.(\d+)\.(\d+)(?::(\d+)){0,1}$");
    private static readonly Regex IPV6_DOUBL_COL_PAT = new Regex(@"^\[{0,1}([0-9a-f:]*)::([0-9a-f:]*)(?:\]:(\d+)){0,1}$");
    private static readonly Regex IPV6_PAT;

    static ParseIPAddress()
    {
        string ipv6Pattern = @"^\[{0,1}";
        for (int i = 1; i <= 7; i++)
        {
            ipv6Pattern += @"([0-9a-f]+):";
        }
        ipv6Pattern += @"([0-9a-f]+)(?:\]:(\d+)){0,1}$";
        IPV6_PAT = new Regex(ipv6Pattern);
    }

    static void Main(string[] args)
    {
        string[] tests = new string[] { "192.168.0.1", "127.0.0.1", "256.0.0.1", "127.0.0.1:80", "::1", "[::1]:80", "[32e::12f]:80", "2605:2700:0:3::4713:93e3", "[2605:2700:0:3::4713:93e3]:80", "2001:db8:85a3:0:0:8a2e:370:7334" };
        Console.WriteLine(String.Format("{0,-40} {1,-32}   {2}", "Test Case", "Hex Address", "Port"));
        foreach (var ip in tests)
        {
            try
            {
                string[] parsed = ParseIP(ip);
                Console.WriteLine(String.Format("{0,-40} {1,-32}   {2}", ip, parsed[0], parsed[1]));
            }
            catch (ArgumentException e)
            {
                Console.WriteLine(String.Format("{0,-40} Invalid address:  {1}", ip, e.Message));
            }
        }
    }



    private static string[] ParseIP(string ip)
    {
        string hex = "";
        string port = "";

        // IPV4
        Match ipv4Matcher = IPV4_PAT.Match(ip);
        if (ipv4Matcher.Success)
        {
            for (int i = 1; i <= 4; i++)
            {
                hex += ToHex4(ipv4Matcher.Groups[i].Value);
            }
            if (ipv4Matcher.Groups[5].Success)
            {
                port = ipv4Matcher.Groups[5].Value;
            }
            return new string[] { hex, port };
        }

        // IPV6, double colon
        Match ipv6DoubleColonMatcher = IPV6_DOUBL_COL_PAT.Match(ip);
        if (ipv6DoubleColonMatcher.Success)
        {
            string p1 = ipv6DoubleColonMatcher.Groups[1].Value;
            if (p1 == "")
            {
                p1 = "0";
            }
            string p2 = ipv6DoubleColonMatcher.Groups[2].Value;
            if (p2 == "")
            {
                p2 = "0";
            }
            ip = p1 + GetZero(8 - NumCount(p1) - NumCount(p2)) + p2;
            if (ipv6DoubleColonMatcher.Groups[3].Success)
            {
                ip = "[" + ip + "]:" + ipv6DoubleColonMatcher.Groups[3].Value;
            }
        }

        // IPV6
        Match ipv6Matcher = IPV6_PAT.Match(ip);
        if (ipv6Matcher.Success)
        {
            for (int i = 1; i <= 8; i++)
            {
                hex += String.Format("{0,4}", ToHex6(ipv6Matcher.Groups[i].Value)).Replace(" ", "0");
            }
            if (ipv6Matcher.Groups[9].Success)
            {
                port = ipv6Matcher.Groups[9].Value;
            }
            return new string[] { hex, port };
        }

        throw new ArgumentException("ERROR 103: Unknown address: " + ip);
    }

    private static int NumCount(string s)
    {
        return s.Split(':').Length;
    }

    private static string GetZero(int count)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(":");
        while (count > 0)
        {
            sb.Append("0:");
            count--;
        }
        return sb.ToString();
    }

    private static string ToHex4(string s)
    {
        int val = int.Parse(s);
        if (val < 0 || val > 255)
        {
            throw new ArgumentException("ERROR 101:  Invalid value : " + s);
        }
        return val.ToString("X2");
    }

    private static string ToHex6(string s)
    {
        int val = int.Parse(s, System.Globalization.NumberStyles.HexNumber);
        if (val < 0 || val > 65536)
        {
            throw new ArgumentException("ERROR 102:  Invalid hex value : " + s);
        }
        return s;
    }
}
