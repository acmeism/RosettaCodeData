namespace RosettaCode {
    class Hofstadter {
        static public int F(int n) {
            int result = 1;
            if (n > 0) {
                result = n - M(F(n-1));
            }

            return result;
        }

        static public int M(int n) {
            int result = 0;
            if (n > 0) {
                result = n - F(M(n - 1));
            }

            return result;
        }
    }
}
