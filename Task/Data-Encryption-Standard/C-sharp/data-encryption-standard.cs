using System;
using System.IO;
using System.Security.Cryptography;

namespace DES {
    class Program {
        //Taken from https://stackoverflow.com/a/311179
        static string ByteArrayToString(byte[] ba) {
            return BitConverter.ToString(ba).Replace("-", "");
        }

        //Modified from https://stackoverflow.com/q/4100996
        //The passwordBytes parameter must be 8 bytes long
        static byte[] Encrypt(byte[] messageBytes, byte[] passwordBytes) {
            byte[] iv = new byte[] { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

            // Set encryption settings -- Use password for both key and init. vector
            DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
            ICryptoTransform transform = provider.CreateEncryptor(passwordBytes, iv);
            CryptoStreamMode mode = CryptoStreamMode.Write;

            // Set up streams and encrypt
            MemoryStream memStream = new MemoryStream();
            CryptoStream cryptoStream = new CryptoStream(memStream, transform, mode);
            cryptoStream.Write(messageBytes, 0, messageBytes.Length);
            cryptoStream.FlushFinalBlock();

            // Read the encrypted message from the memory stream
            byte[] encryptedMessageBytes = new byte[memStream.Length];
            memStream.Position = 0;
            memStream.Read(encryptedMessageBytes, 0, encryptedMessageBytes.Length);

            return encryptedMessageBytes;
        }

        //Modified from https://stackoverflow.com/q/4100996
        //The passwordBytes parameter must be 8 bytes long
        static byte[] Decrypt(byte[] encryptedMessageBytes, byte[] passwordBytes) {
            byte[] iv = new byte[] { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

            // Set encryption settings -- Use password for both key and init. vector
            DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
            ICryptoTransform transform = provider.CreateDecryptor(passwordBytes, iv);
            CryptoStreamMode mode = CryptoStreamMode.Write;

            // Set up streams and decrypt
            MemoryStream memStream = new MemoryStream();
            CryptoStream cryptoStream = new CryptoStream(memStream, transform, mode);
            cryptoStream.Write(encryptedMessageBytes, 0, encryptedMessageBytes.Length);
            cryptoStream.FlushFinalBlock();

            // Read decrypted message from memory stream
            byte[] decryptedMessageBytes = new byte[memStream.Length];
            memStream.Position = 0;
            memStream.Read(decryptedMessageBytes, 0, decryptedMessageBytes.Length);

            return decryptedMessageBytes;
        }

        static void Main(string[] args) {
            byte[] keyBytes = new byte[] { 0x0e, 0x32, 0x92, 0x32, 0xea, 0x6d, 0x0d, 0x73 };
            byte[] plainBytes = new byte[] { 0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87 };

            byte[] encStr = Encrypt(plainBytes, keyBytes);
            Console.WriteLine("Encoded: {0}", ByteArrayToString(encStr));

            byte[] decBytes = Decrypt(encStr, keyBytes);
            Console.WriteLine("Decoded: {0}", ByteArrayToString(decBytes));
        }
    }
}
