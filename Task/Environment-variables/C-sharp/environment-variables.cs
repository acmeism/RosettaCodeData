using System;

namespace RosettaCode {
    class Program {
        static void Main() {
            string temp = Environment.GetEnvironmentVariable("TEMP");
            Console.WriteLine("TEMP is " + temp);
        }
    }
}
