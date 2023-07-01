using System;
using System.IO;

namespace RosettaCode {
    class Program {
        static void Main() {
            try {
                File.Delete("input.txt");
                Directory.Delete("docs");
                File.Delete(@"\input.txt");
                Directory.Delete(@"\docs");
            } catch (Exception exception) {
                Console.WriteLine(exception.Message);
            }
        }
    }
}
