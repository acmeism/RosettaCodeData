using System;

namespace VigenereCipher
{
    class VCipher
    {
        public string encrypt(string txt, string pw, int d)
        {
            int pwi = 0, tmp;
            string ns = "";
            txt = txt.ToUpper();
            pw = pw.ToUpper();
            foreach (char t in txt)
            {
                if (t < 65) continue;
                tmp = t - 65 + d * (pw[pwi] - 65);
                if (tmp < 0) tmp += 26;
                ns += Convert.ToChar(65 + ( tmp % 26) );
                if (++pwi == pw.Length) pwi = 0;
            }

            return ns;
        }
    };

    class Program
    {
        static void Main(string[] args)
        {
            VCipher v = new VCipher();

            string s0 = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!",
                   pw = "VIGENERECIPHER";

            Console.WriteLine(s0 + "\n" + pw + "\n");
            string s1 = v.encrypt(s0, pw, 1);
            Console.WriteLine("Encrypted: " + s1);
            s1 = v.encrypt(s1, "VIGENERECIPHER", -1);
            Console.WriteLine("Decrypted: " + s1);
            Console.WriteLine("\nPress any key to continue...");
            Console.ReadKey();
        }
    }
}
