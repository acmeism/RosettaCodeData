using System;
using System.Net;
using System.Linq;

public class Program
{
    public static void Main()
    {
        string[] tests = {
            "87.70.141.1/22",
            "36.18.154.103/12",
            "62.62.197.11/29",
            "67.137.119.181/4",
            "161.214.74.21/24",
            "184.232.176.184/18"
        };

        foreach (string t in tests) Console.WriteLine($"{t}   =>   {Canonicalize(t)}");
    }

    static string Canonicalize(string cidr) => CIDR.Parse(cidr).Canonicalize().ToString();
}

readonly struct CIDR
{
    public readonly IPAddress ip;
    public readonly int length;

    public static CIDR Parse(string cidr)
    {
        string[] parts = cidr.Split('/');
        return new CIDR(IPAddress.Parse(parts[0]), int.Parse(parts[1]));
    }

    public CIDR(IPAddress ip, int length) => (this.ip, this.length) = (ip, length);

    public CIDR Canonicalize() =>
        new CIDR(
            new IPAddress(
                ToBytes(
                    ToInt(
                        ip.GetAddressBytes()
                    )
                    & ~((1 << (32 - length)) - 1)
                )
            ),
            length
        );

    private int ToInt(byte[] bytes) => bytes.Aggregate(0, (n, b) => (n << 8) | b);

    private byte[] ToBytes(int n)
    {
        byte[] bytes = new byte[4];
        for (int i = 3; i >= 0; i--) {
            bytes[i] = (byte)(n & 0xFF);
            n >>= 8;
        }
        return bytes;
    }

    public override string ToString() => $"{ip}/{length}";
}
