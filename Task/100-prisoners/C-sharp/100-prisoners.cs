using System;
using System.Linq;

namespace Prisoners {
    class Program {
        static bool PlayOptimal() {
            var secrets = Enumerable.Range(0, 100).OrderBy(a => Guid.NewGuid()).ToList();

            for (int p = 0; p < 100; p++) {
                bool success = false;

                var choice = p;
                for (int i = 0; i < 50; i++) {
                    if (secrets[choice] == p) {
                        success = true;
                        break;
                    }
                    choice = secrets[choice];
                }

                if (!success) {
                    return false;
                }
            }

            return true;
        }

        static bool PlayRandom() {
            var secrets = Enumerable.Range(0, 100).OrderBy(a => Guid.NewGuid()).ToList();

            for (int p = 0; p < 100; p++) {
                var choices = Enumerable.Range(0, 100).OrderBy(a => Guid.NewGuid()).ToList();

                bool success = false;
                for (int i = 0; i < 50; i++) {
                    if (choices[i] == p) {
                        success = true;
                        break;
                    }
                }

                if (!success) {
                    return false;
                }
            }

            return true;
        }

        static double Exec(uint n, Func<bool> play) {
            uint success = 0;
            for (uint i = 0; i < n; i++) {
                if (play()) {
                    success++;
                }
            }
            return 100.0 * success / n;
        }

        static void Main() {
            const uint N = 1_000_000;
            Console.WriteLine("# of executions: {0}", N);
            Console.WriteLine("Optimal play success rate: {0:0.00000000000}%", Exec(N, PlayOptimal));
            Console.WriteLine(" Random play success rate: {0:0.00000000000}%", Exec(N, PlayRandom));
        }
    }
}
