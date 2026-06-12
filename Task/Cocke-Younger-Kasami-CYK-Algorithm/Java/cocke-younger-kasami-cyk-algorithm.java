import java.util.*;

public class CYKParser {
    private List<String> nonTerminals;
    private List<String> terminals;
    private Map<String, List<List<String>>> rules;

    public CYKParser() {
        nonTerminals = Arrays.asList("NP", "Nom", "Det", "AP", "Adv", "A");
        terminals = Arrays.asList("book", "orange", "man", "tall", "heavy", "very", "muscular");

        rules = new HashMap<>();
        rules.put("NP", Arrays.asList(Arrays.asList("Det", "Nom")));
        rules.put("Nom", Arrays.asList(
            Arrays.asList("AP", "Nom"),
            Arrays.asList("book"),
            Arrays.asList("orange"),
            Arrays.asList("man")
        ));
        rules.put("AP", Arrays.asList(
            Arrays.asList("Adv", "A"),
            Arrays.asList("heavy"),
            Arrays.asList("orange"),
            Arrays.asList("tall")
        ));
        rules.put("Det", Arrays.asList(Arrays.asList("a")));
        rules.put("Adv", Arrays.asList(Arrays.asList("very"), Arrays.asList("extremely")));
        rules.put("A", Arrays.asList(
            Arrays.asList("heavy"),
            Arrays.asList("orange"),
            Arrays.asList("tall"),
            Arrays.asList("muscular")
        ));
    }

    public void parse(String[] w) {
        int n = w.length;

        // Initialize the table with empty sets
        @SuppressWarnings("unchecked")
        Set<String>[][] T = new HashSet[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                T[i][j] = new HashSet<>();
            }
        }

        // Fill in the table
        for (int j = 0; j < n; j++) {
            // Check terminal rules
            for (Map.Entry<String, List<List<String>>> entry : rules.entrySet()) {
                String lhs = entry.getKey();
                for (List<String> rhs : entry.getValue()) {
                    if (rhs.size() == 1 && rhs.get(0).equals(w[j])) {
                        T[j][j].add(lhs);
                    }
                }
            }

            for (int i = j; i >= 0; i--) {
                // Iterate over the range i to j
                for (int k = i; k < j; k++) {
                    // Check binary rules
                    for (Map.Entry<String, List<List<String>>> entry : rules.entrySet()) {
                        String lhs = entry.getKey();
                        for (List<String> rhs : entry.getValue()) {
                            if (rhs.size() == 2 &&
                                T[i][k].contains(rhs.get(0)) &&
                                T[k+1][j].contains(rhs.get(1))) {
                                T[i][j].add(lhs);
                            }
                        }
                    }
                }
            }
        }

        // Check if the sentence can be parsed as NP
        System.out.println(T[0][n-1].contains("NP") ? "True" : "False");
    }

    public static void main(String[] args) {
        String[] w = "a very heavy orange book".split(" ");
        CYKParser parser = new CYKParser();
        parser.parse(w);
    }
}
