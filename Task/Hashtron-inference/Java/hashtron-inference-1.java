public class Main {
	
    public static long inference(int command, int bits, int[][] program) {
        long out = 0;

        // Check if the program is empty
        if ( program.length == 0 ) {
            return out;
        }

        // Iterate over the bits
        for ( int j = 0; j < bits; j++ ) {
            int input = command | ( j << 16);
            int ss = program[0][0];
            int maxx = program[0][1];
            input = hash(input, ss, maxx);
            for ( int i = 1; i < program.length; i++ ) {
                int s = program[i][0];
                int max = program[i][1];
                maxx -= max;
                input = hash(input, s, maxx);
            }
            input &= 1;
            if (input != 0) {
            	out |= (long)1 << (long) j;
            }
        }
        return out;
    }

    public static int hash(int n, int s, int max_val) {
        // Mixing stage, mix input with salt using subtraction
        long m = (n - s) & 0xFFFFFFFFL;

        // Hashing stage, use xor shift with prime coefficients
        m ^= (m << 2) & 0xFFFFFFFFL;
        m ^= (m << 3) & 0xFFFFFFFFL;
        m ^= (m >> 5) & 0xFFFFFFFFL;
        m ^= (m >> 7) & 0xFFFFFFFFL;
        m ^= (m << 11) & 0xFFFFFFFFL;
        m ^= (m << 13) & 0xFFFFFFFFL;
        m ^= (m >> 17) & 0xFFFFFFFFL;
        m ^= (m << 19) & 0xFFFFFFFFL;

        // Mixing stage 2, mix input with salt using addition
        m += s;
        m &= 0xFFFFFFFFL;

        // Modular stage using Lemire's fast alternative to modulo reduction
        return (int) ( ( ( m * max_val ) >>> 32 ) & 0xFFFFFFFFL );
    }

    public static void main(String[] args) {
        int command = 42;
        int[][] program = { { 0, 2 } }; // Example program
	    int bits = 64;
        long result = inference(command, bits, program);
        System.out.println(Long.toUnsignedString(result));
    }
}
