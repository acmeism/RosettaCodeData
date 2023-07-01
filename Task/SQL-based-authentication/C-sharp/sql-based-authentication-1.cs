using System.Security.Cryptography;
using System.Text;

namespace rosettaMySQL
{
    class Hasher
    {
        private static string _BytesToHex(byte[] input)
        {
            var strBuilder = new StringBuilder();
            foreach (byte _byte in input)
            {
                strBuilder.Append(_byte.ToString("x2"));
            }
            return strBuilder.ToString();
        }

        public static string Hash(string salt, string input)
        {
            using (MD5 md5 = new MD5CryptoServiceProvider())
            {
                var bytes = Encoding.Default.GetBytes(salt + input);
                var data = md5.ComputeHash(bytes);
                return _BytesToHex(data);
            }
        }

        public static string GenSalt()
        {
            using (RandomNumberGenerator rng = new RNGCryptoServiceProvider())
            {
                var salt = new byte[16];
                rng.GetBytes(salt);
                return _BytesToHex(salt);
            }
        }
    }
}
