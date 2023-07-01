import java.util.*;

public class HashJoin {

    public static void main(String[] args) {
        String[][] table1 = {{"27", "Jonah"}, {"18", "Alan"}, {"28", "Glory"},
        {"18", "Popeye"}, {"28", "Alan"}};

        String[][] table2 = {{"Jonah", "Whales"}, {"Jonah", "Spiders"},
        {"Alan", "Ghosts"}, {"Alan", "Zombies"}, {"Glory", "Buffy"},
        {"Bob", "foo"}};

        hashJoin(table1, 1, table2, 0).stream()
                .forEach(r -> System.out.println(Arrays.deepToString(r)));
    }

    static List<String[][]> hashJoin(String[][] records1, int idx1,
            String[][] records2, int idx2) {

        List<String[][]> result = new ArrayList<>();
        Map<String, List<String[]>> map = new HashMap<>();

        for (String[] record : records1) {
            List<String[]> v = map.getOrDefault(record[idx1], new ArrayList<>());
            v.add(record);
            map.put(record[idx1], v);
        }

        for (String[] record : records2) {
            List<String[]> lst = map.get(record[idx2]);
            if (lst != null) {
                lst.stream().forEach(r -> {
                    result.add(new String[][]{r, record});
                });
            }
        }

        return result;
    }
}
