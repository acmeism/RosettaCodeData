using System;

namespace RosettaCode {
    class Program {
        static void Main() {
            string[] args = Environment.GetCommandLineArgs();
            for (int i = 0; i < args.Length; i++)
                Console.WriteLine(String.Format("Argument {0} is '{1}'", i, args[i]));
        }
    }
}
