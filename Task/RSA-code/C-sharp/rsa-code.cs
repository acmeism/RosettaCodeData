using System;
using System.Numerics;
using System.Text;

class Program
{
    static void Main(string[] args)
    {
        BigInteger n = BigInteger.Parse("9516311845790656153499716760847001433441357");
        BigInteger e = 65537;
        BigInteger d = BigInteger.Parse("5617843187844953170308463622230283376298685");

        const string plaintextstring = "Hello, Rosetta!";
        byte[] plaintext = ASCIIEncoding.ASCII.GetBytes(plaintextstring);
        BigInteger pt = new BigInteger(plaintext);
        if (pt > n)
            throw new Exception();

        BigInteger ct = BigInteger.ModPow(pt, e, n);
        Console.WriteLine("Encoded:  " + ct);

        BigInteger dc = BigInteger.ModPow(ct, d, n);
        Console.WriteLine("Decoded:  " + dc);

        string decoded = ASCIIEncoding.ASCII.GetString(dc.ToByteArray());
        Console.WriteLine("As ASCII: " + decoded);
    }
}
