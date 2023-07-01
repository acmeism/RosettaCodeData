public class McNuggets {

    public static void main(String... args) {
        int[] SIZES = new int[] { 6, 9, 20 };
        int MAX_TOTAL = 100;
        // Works like Sieve of Eratosthenes
        int numSizes = SIZES.length;
        int[] counts = new int[numSizes];
        int maxFound = MAX_TOTAL + 1;
        boolean[] found = new boolean[maxFound];
        int numFound = 0;
        int total = 0;
        boolean advancedState = false;
        do {
            if (!found[total]) {
                found[total] = true;
                numFound++;
            }

            // Advance state
            advancedState = false;
            for (int i = 0; i < numSizes; i++) {
                int curSize = SIZES[i];
                if ((total + curSize) > MAX_TOTAL) {
                    // Reset to zero and go to the next box size
                    total -= counts[i] * curSize;
                    counts[i] = 0;
                }
                else {
                    // Adding a box of this size still keeps the total at or below the maximum
                    counts[i]++;
                    total += curSize;
                    advancedState = true;
                    break;
                }
            }

        } while ((numFound < maxFound) && advancedState);

        if (numFound < maxFound) {
            // Did not find all counts within the search space
            for (int i = MAX_TOTAL; i >= 0; i--) {
                if (!found[i]) {
                    System.out.println("Largest non-McNugget number in the search space is " + i);
                    break;
                }
            }
        }
        else {
            System.out.println("All numbers in the search space are McNugget numbers");
        }

        return;
    }
}
