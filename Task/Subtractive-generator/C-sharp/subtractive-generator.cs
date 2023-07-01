public class SubtractiveGenerator {
    public static int MAX = 1000000000;
    private int[] state;
    private int pos;

    private int mod(int n) {
        return ((n % MAX) + MAX) % MAX;
    }

    public SubtractiveGenerator(int seed) {
        state = new int[55];

        int[] temp = new int[55];
        temp[0] = mod(seed);
        temp[1] = 1;
        for(int i = 2; i < 55; ++i)
            temp[i] = mod(temp[i - 2] - temp[i - 1]);

        for(int i = 0; i < 55; ++i)
            state[i] = temp[(34 * (i + 1)) % 55];

        pos = 54;
        for(int i = 55; i < 220; ++i)
            next();
    }

    public int next() {
        int temp = mod(state[(pos + 1) % 55] - state[(pos + 32) % 55]);
        pos = (pos + 1) % 55;
        state[pos] = temp;
        return temp;
    }

    static void Main(string[] args) {
        SubtractiveGenerator gen = new SubtractiveGenerator(292929);
        for(int i = 220; i < 230; ++i)
            Console.WriteLine(i.ToString() + ": " + gen.next().ToString());
    }
}
