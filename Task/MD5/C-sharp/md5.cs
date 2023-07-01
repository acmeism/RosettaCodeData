using System.Text;
using System.Security.Cryptography;

byte[] data = Encoding.ASCII.GetBytes("The quick brown fox jumped over the lazy dog's back");
byte[] hash = MD5.Create().ComputeHash(data);
Console.WriteLine(BitConverter.ToString(hash).Replace("-", "").ToLower());
