import java.util.List;
import java.util.Arrays;

List<String> haystack = Arrays.asList("Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo");

for (String needle : new String[]{"Washington","Bush"}) {
    int index = haystack.indexOf(needle);
    if (index < 0)
        System.out.println(needle + " is not in haystack");
    else
        System.out.println(index + " " + needle);
}
