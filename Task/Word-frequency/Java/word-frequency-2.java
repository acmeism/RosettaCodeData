void printWordFrequency() throws URISyntaxException, IOException {
    URL url = new URI("https://www.gutenberg.org/files/135/135-0.txt").toURL();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()))) {
        Pattern pattern = Pattern.compile("(\\w+)");
        Matcher matcher;
        String line;
        String word;
        Map<String, Integer> map = new HashMap<>();
        while ((line = reader.readLine()) != null) {
            matcher = pattern.matcher(line);
            while (matcher.find()) {
                word = matcher.group().toLowerCase();
                if (map.containsKey(word)) {
                    map.put(word, map.get(word) + 1);
                } else {
                    map.put(word, 1);
                }
            }
        }
        /* print out top 10 */
        List<Map.Entry<String, Integer>> list = new ArrayList<>(map.entrySet());
        list.sort(Map.Entry.comparingByValue());
        Collections.reverse(list);
        int count = 1;
        for (Map.Entry<String, Integer> value : list) {
            System.out.printf("%-20s%,7d%n", value.getKey(), value.getValue());
            if (count++ == 10) break;
        }
    }
}
