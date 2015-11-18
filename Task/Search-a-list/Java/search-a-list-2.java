import java.util.Arrays;

String[] haystack = { "Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"};

for (String needle : new String[]{"Washington","Bush"}) {
    int index = Arrays.binarySearch(haystack, needle);
    if (index < 0)
        System.out.println(needle + " is not in haystack");
    else
        System.out.println(index + " " + needle);
}
