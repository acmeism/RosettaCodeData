import java.util.*;
import java.util.stream.*;

public class StateNamePuzzle {

    static String[] states = {"Alabama", "Alaska", "Arizona", "Arkansas",
        "California", "Colorado", "Connecticut", "Delaware", "Florida",
        "Georgia", "hawaii", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
        "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
        "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana",
        "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
        "New York", "North Carolina ", "North Dakota", "Ohio", "Oklahoma",
        "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
        "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
        "Washington", "West Virginia", "Wisconsin", "Wyoming",
        "New Kory", "Wen Kory", "York New", "Kory New", "New Kory",};

    public static void main(String[] args) {
        solve(Arrays.asList(states));
    }

    static void solve(List<String> input) {
        Map<String, String> orig = input.stream().collect(Collectors.toMap(
                s -> s.replaceAll("\\s", "").toLowerCase(), s -> s, (s, a) -> s));

        input = new ArrayList<>(orig.keySet());

        Map<String, List<String[]>> map = new HashMap<>();
        for (int i = 0; i < input.size() - 1; i++) {
            String pair0 = input.get(i);
            for (int j = i + 1; j < input.size(); j++) {

                String[] pair = {pair0, input.get(j)};
                String s = pair0 + pair[1];
                String key = Arrays.toString(s.chars().sorted().toArray());

                List<String[]> val;
                if ((val = map.get(key)) == null)
                    val = new ArrayList<>();
                val.add(pair);
                map.put(key, val);
            }
        }

        map.forEach((key, list) -> {
            for (int i = 0; i < list.size() - 1; i++) {
                String[] a = list.get(i);
                for (int j = i + 1; j < list.size(); j++) {
                    String[] b = list.get(j);

                    if (Stream.of(a[0], a[1], b[0], b[1]).distinct().count() < 4)
                        continue;

                    System.out.printf("%s + %s = %s + %s %n", orig.get(a[0]),
                            orig.get(a[1]), orig.get(b[0]), orig.get(b[1]));
                }
            }
        });
    }
}
