String[] haystack = {"Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"};

OUTERLOOP:
for (String needle : new String[]{"Washington","Bush"}) {
    for (int i = 0; i < haystack.length; i++)
        if (needle.equals(haystack[i])) {
            System.out.println(i + " " + needle);
            continue OUTERLOOP;
        }
    System.out.println(needle + " is not in haystack");
}
