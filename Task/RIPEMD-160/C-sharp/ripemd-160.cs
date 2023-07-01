using System;
using System.Security.Cryptography;
using System.Text;

class Program
{
    static void Main(string[] args)
    {
        string text = "Rosetta Code";
        byte[] bytes = Encoding.ASCII.GetBytes(text);
        RIPEMD160 myRIPEMD160 = RIPEMD160Managed.Create();
        byte[] hashValue = myRIPEMD160.ComputeHash(bytes);
        var hexdigest = BitConverter.ToString(hashValue).Replace("-", "").ToLower();
        Console.WriteLine(hexdigest);
        Console.ReadLine();
    }
}
