public static Map<Integer, Long> countLetters(String filename) throws IOException {
    return Files.lines(Paths.get(filename))
        .flatMapToInt(String::chars)
        .filter(Character::isLetter)
        .boxed()
        .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
}
