using System;

namespace SpecialDivisors {
    class Program {
        static int Reverse(int n) {
            int result = 0;
            while (n > 0) {
                result = 10 * result + n % 10;
                n /= 10;
            }
            return result;
        }

        static void Main() {
            const int LIMIT = 200;

            int row = 0;
            int num = 0;

            for (int n = 1; n < LIMIT; n++) {
                bool flag = true;
                int revNum = Reverse(n);

                for (int m = 1; m < n / 2; m++) {
                    int revDiv = Reverse(m);
                    if (n % m == 0) {
                        if (revNum % revDiv == 0) {
                            flag = true;
                        } else {
                            flag = false;
                            break;
                        }
                    }
                }

                if (flag) {
                    num++;
                    row++;
                    Console.Write("{0,4}", n);
                    if (row % 10 == 0) {
                        Console.WriteLine();
                    }
                }
            }

            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine("Found {0} special divisors N that reverse(D) divides reverse(N) for all divisors D of N, where N < 200", num);
        }
    }
}
