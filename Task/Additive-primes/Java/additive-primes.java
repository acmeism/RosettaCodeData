public class additivePrimes {

    public static void main(String[] args) {
        int additive_primes = 0;
        for (int i = 2; i < 500; i++) {
            if(isPrime(i) && isPrime(digitSum(i))){
                additive_primes++;
                System.out.print(i + " ");
            }
        }
        System.out.print("\nFound " + additive_primes + " additive primes less than 500");
    }

    static boolean isPrime(int n) {
        int counter = 1;
        if (n < 2 || (n != 2 && n % 2 == 0) || (n != 3 && n % 3 == 0)) {
            return false;
        }
        while (counter * 6 - 1 <= Math.sqrt(n)) {
            if (n % (counter * 6 - 1) == 0 || n % (counter * 6 + 1) == 0) {
                return false;
            } else {
                counter++;
            }
        }
        return true;
    }

    static int digitSum(int n) {
        int sum = 0;
        while (n > 0) {
            sum += n % 10;
            n /= 10;
        }
        return sum;
    }
}
