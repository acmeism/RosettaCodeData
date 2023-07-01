using System;
using System.Linq;
using System.Security.Cryptography;
using NUnit.Framework;

namespace BitcoinValidator
{
    public class ValidateTest
    {
        [TestCase]
        public void ValidateBitcoinAddressTest()
        {
            Assert.IsTrue(ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i")); // VALID
            Assert.IsTrue(ValidateBitcoinAddress("1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9")); // VALID
            Assert.Throws<Exception>(() => ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X")); // checksum changed, original data
            Assert.Throws<Exception>(() => ValidateBitcoinAddress("1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i")); // data changed, original checksum
            Assert.Throws<Exception>(() => ValidateBitcoinAddress("1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i")); // invalid chars
            Assert.Throws<Exception>(() => ValidateBitcoinAddress("BZbvjr")); // checksum is fine, address too short
        }

        public static bool ValidateBitcoinAddress(string address)
        {
            if (address.Length < 26 || address.Length > 35) throw new Exception("wrong length");
            var decoded = DecodeBase58(address);
            var d1 = Hash(decoded.SubArray(0, 21));
            var d2 = Hash(d1);
            if (!decoded.SubArray(21, 4).SequenceEqual(d2.SubArray(0, 4))) throw new Exception("bad digest");
            return true;
        }

        const string Alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
        const int Size = 25;

        private static byte[] DecodeBase58(string input)
        {
            var output = new byte[Size];
            foreach (var t in input)
            {
                var p = Alphabet.IndexOf(t);
                if (p == -1) throw new Exception("invalid character found");
                var j = Size;
                while (--j > 0)
                {
                    p += 58 * output[j];
                    output[j] = (byte)(p % 256);
                    p /= 256;
                }
                if (p != 0) throw new Exception("address too long");
            }
            return output;
        }

        private static byte[] Hash(byte[] bytes)
        {
            var hasher = new SHA256Managed();
            return hasher.ComputeHash(bytes);
        }
    }

    public static class ArrayExtensions
    {
        public static T[] SubArray<T>(this T[] data, int index, int length)
        {
            var result = new T[length];
            Array.Copy(data, index, result, 0, length);
            return result;
        }
    }
}
