void printCompare(String stringA, String stringB) {
    if (stringA.length() > stringB.length()) {
        System.out.printf("%d %s%n", stringA.length(), stringA);
        System.out.printf("%d %s%n", stringB.length(), stringB);
    } else {
        System.out.printf("%d %s%n", stringB.length(), stringB);
        System.out.printf("%d %s%n", stringA.length(), stringA);
    }
}

void printDescending(String... strings) {
    List<String> list = new ArrayList<>(List.of(strings));
    list.sort(Comparator.comparingInt(String::length).reversed());
    for (String string : list)
        System.out.printf("%d %s%n", string.length(), string);
}
