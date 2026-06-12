import java.util.List;

public class App {
    private static String lcs(List<String> a) {
        var le = a.size();
        if (le == 0) {
            return "";
        }
        if (le == 1) {
            return a.get(0);
        }
        var le0 = a.get(0).length();
        var minLen = le0;
        for (int i = 1; i < le; i++) {
            if (a.get(i).length() < minLen) {
                minLen = a.get(i).length();
            }
        }
        if (minLen == 0) {
            return "";
        }
        var res = "";
        var a1 = a.subList(1, a.size());
        for (int i = 1; i < minLen; i++) {
            var suffix = a.get(0).substring(le0 - i);
            for (String e : a1) {
                if (!e.endsWith(suffix)) {
                    return res;
                }
            }
            res = suffix;
        }
        return "";
    }

    public static void main(String[] args) {
        var tests = List.of(
            List.of("baabababc", "baabc", "bbbabc"),
            List.of("baabababc", "baabc", "bbbazc"),
            List.of("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
            List.of("longest", "common", "suffix"),
            List.of("suffix"),
            List.of("")
        );
        for (List<String> test : tests) {
            System.out.printf("%s -> `%s`\n", test, lcs(test));
        }
    }
}
