public class SubsetSum {
    private static class Item {
        private String word;
        private int weight;

        public Item(String word, int weight) {
            this.word = word;
            this.weight = weight;
        }

        @Override
        public String toString() {
            return String.format("(%s, %d)", word, weight);
        }
    }

    private static Item[] items = new Item[]{
        new Item("alliance", -624),
        new Item("archbishop", -915),
        new Item("balm", 397),
        new Item("bonnet", 452),
        new Item("brute", 870),
        new Item("centipede", -658),
        new Item("cobol", 362),
        new Item("covariate", 590),
        new Item("departure", 952),
        new Item("deploy", 44),
        new Item("diophantine", 645),
        new Item("efferent", 54),
        new Item("elysee", -326),
        new Item("eradicate", 376),
        new Item("escritoire", 856),
        new Item("exorcism", -983),
        new Item("fiat", 170),
        new Item("filmy", -874),
        new Item("flatworm", 503),
        new Item("gestapo", 915),
        new Item("infra", -847),
        new Item("isis", -982),
        new Item("lindholm", 999),
        new Item("markham", 475),
        new Item("mincemeat", -880),
        new Item("moresby", 756),
        new Item("mycenae", 183),
        new Item("plugging", -266),
        new Item("smokescreen", 423),
        new Item("speakeasy", -745),
        new Item("vein", 813),
    };

    private static final int n = items.length;
    private static final int[] indices = new int[n];
    private static int count = 0;

    private static final int LIMIT = 5;

    private static void zeroSum(int i, int w) {
        if (i != 0 && w == 0) {
            for (int j = 0; j < i; ++j) {
                System.out.printf("%s ", items[indices[j]]);
            }
            System.out.println("\n");
            if (count < LIMIT) count++;
            else return;
        }
        int k = (i != 0) ? indices[i - 1] + 1 : 0;
        for (int j = k; j < n; ++j) {
            indices[i] = j;
            zeroSum(i + 1, w + items[j].weight);
            if (count == LIMIT) return;
        }
    }

    public static void main(String[] args) {
        System.out.printf("The weights of the following %d subsets add up to zero:\n\n", LIMIT);
        zeroSum(0, 0);
    }
}
