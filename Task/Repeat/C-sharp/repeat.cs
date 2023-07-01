using System;

namespace Repeat {
    class Program {
        static void Repeat(int count, Action<int> fn) {
            if (null == fn) {
                throw new ArgumentNullException("fn");
            }
            for (int i = 0; i < count; i++) {
                fn.Invoke(i + 1);
            }
        }

        static void Main(string[] args) {
            Repeat(3, x => Console.WriteLine("Example {0}", x));
        }
    }
}
