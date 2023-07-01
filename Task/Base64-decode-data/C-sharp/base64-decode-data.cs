using System;
using System.Text;

namespace Base64DecodeData {
    class Program {
        static void Main(string[] args) {
            var data = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=";
            Console.WriteLine(data);
            Console.WriteLine();

            var decoded = Encoding.ASCII.GetString(Convert.FromBase64String(data));
            Console.WriteLine(decoded);
        }
    }
}
