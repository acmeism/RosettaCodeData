public class PermutationGenerator {
    private int[] array;
    private int firstNum;
    private boolean firstReady = false;

    public PermutationGenerator(int n, int firstNum_) {
        if (n < 1) {
            throw new IllegalArgumentException("The n must be min. 1");
        }
        firstNum = firstNum_;
        array = new int[n];
        reset();
    }

    public void reset() {
        for (int i = 0; i < array.length; i++) {
            array[i] = i + firstNum;
        }
        firstReady = false;
    }

    public boolean hasMore() {
        boolean end = firstReady;
        for (int i = 1; i < array.length; i++) {
            end = end && array[i] < array[i-1];
        }
        return !end;
    }

    public int[] getNext() {

        if (!firstReady) {
            firstReady = true;
            return array;
        }

        int temp;
        int j = array.length - 2;
        int k = array.length - 1;

        // Find largest index j with a[j] < a[j+1]

        for (;array[j] > array[j+1]; j--);

        // Find index k such that a[k] is smallest integer
        // greater than a[j] to the right of a[j]

        for (;array[j] > array[k]; k--);

        // Interchange a[j] and a[k]

        temp = array[k];
        array[k] = array[j];
        array[j] = temp;

        // Put tail end of permutation after jth position in increasing order

        int r = array.length - 1;
        int s = j + 1;

        while (r > s) {
            temp = array[s];
            array[s++] = array[r];
            array[r--] = temp;
        }

        return array;
    } // getNext()

    // For testing of the PermutationGenerator class
    public static void main(String[] args) {
        PermutationGenerator pg = new PermutationGenerator(3, 1);

        while (pg.hasMore()) {
            int[] temp =  pg.getNext();
            for (int i = 0; i < temp.length; i++) {
                System.out.print(temp[i] + " ");
            }
            System.out.println();
        }
    }

} // class
