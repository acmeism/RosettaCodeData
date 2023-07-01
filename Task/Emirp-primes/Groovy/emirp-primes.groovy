class Emirp {

    //trivial prime algorithm, sub in whatever algorithm you want
    static boolean isPrime(long x) {
        if (x < 2) return false
        if (x == 2) return true
        if ((x & 1) == 0) return false

        for (long i = 3; i <= Math.sqrt(x); i += 2) {
            if (x % i == 0) return false
        }

        return true
    }

    static boolean isEmirp(long x) {
        String xString = Long.toString(x)
        if (xString.length() == 1) return false
        if (xString.matches("[24568].*") || xString.matches(".*[24568]")) return false //eliminate some easy rejects
        long xR = Long.parseLong(new StringBuilder(xString).reverse().toString())
        if (xR == x) return false
        return isPrime(x) && isPrime(xR)
    }

    static void main(String[] args) {
        int count = 0
        long x = 1

        println("First 20 emirps:")
        while (count < 20) {
            if (isEmirp(x)) {
                count++
                print(x + " ")
            }
            x++
        }

        println("\nEmirps between 7700 and 8000:")
        for (x = 7700; x <= 8000; x++) {
            if (isEmirp(x)) {
                print(x + " ")
            }
        }

        println("\n10,000th emirp:")
        x = 1
        count = 0
        for (; count < 10000; x++) {
            if (isEmirp(x)) {
                count++
            }
        }
        //--x to fix the last increment from the loop
        println(--x)
    }
}
