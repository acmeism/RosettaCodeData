public class Test {

    public static void main(String[] args) {

        // let n be zero
        int n = 0;

        // repeat the following action
        do {

            // increase n by 1
            n++;

        // while the modulo of n times n is not equal to 269696
        } while (n * n % 1000_000 != 269696);

        // show the result
        System.out.println(n);
    }
}
