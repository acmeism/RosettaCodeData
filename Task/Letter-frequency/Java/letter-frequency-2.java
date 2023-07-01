public static void main(String[] args) throws IOException {
    Map<Integer, Integer> frequencies = frequencies("src/LetterFrequency.java");
    System.out.println(print(frequencies));
}

static String print(Map<Integer, Integer> frequencies) {
    StringBuilder string = new StringBuilder();
    int key;
    for (Map.Entry<Integer, Integer> entry : frequencies.entrySet()) {
        key = entry.getKey();
        string.append("%,-8d".formatted(entry.getValue()));
        /* display the hexadecimal value for non-printable characters */
        if ((key >= 0 && key < 32) || key == 127) {
            string.append("%02x%n".formatted(key));
        } else {
            string.append("%s%n".formatted((char) key));
        }
    }
    return string.toString();
}

static Map<Integer, Integer> frequencies(String path) throws IOException {
    try (InputStreamReader reader = new InputStreamReader(new FileInputStream(path))) {
        /* key = character, and value = occurrences */
        Map<Integer, Integer> map = new HashMap<>();
        int value;
        while ((value = reader.read()) != -1) {
            if (map.containsKey(value)) {
                map.put(value, map.get(value) + 1);
            } else {
                map.put(value, 1);
            }
        }
        return map;
    }
}
