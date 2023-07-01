using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Parallel.For(0, 26, a => {
            byte[] password = new byte[5];
            byte[] hash;
            byte[] one = StringHashToByteArray("1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad");
            byte[] two = StringHashToByteArray("3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b");
            byte[] three = StringHashToByteArray("74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f");
            password[0] = (byte)(97 + a);
            var sha = System.Security.Cryptography.SHA256.Create();
            for (password[1] = 97; password[1] < 123; password[1]++)
                for (password[2] = 97; password[2] < 123; password[2]++)
                    for (password[3] = 97; password[3] < 123; password[3]++)
                        for (password[4] = 97; password[4] < 123; password[4]++)
                        {
                            hash = sha.ComputeHash(password);
                            if (matches(one, hash) || matches(two, hash) || matches(three, hash))
                                Console.WriteLine(Encoding.ASCII.GetString(password) + " => "
                                    + BitConverter.ToString(hash).ToLower().Replace("-", ""));
                        }
        });
    }
    static byte[] StringHashToByteArray(string s)
    {
        return Enumerable.Range(0, s.Length / 2).Select(i => (byte)Convert.ToInt16(s.Substring(i * 2, 2), 16)).ToArray();
    }
    static bool matches(byte[] a, byte[] b)
    {
        for (int i = 0; i < 32; i++)
            if (a[i] != b[i])
                return false;
        return true;
    }
}
