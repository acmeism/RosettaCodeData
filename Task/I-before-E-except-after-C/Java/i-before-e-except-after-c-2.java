public static void main(String[] args) throws URISyntaxException, IOException {
    count();
    System.out.printf("%-10s %,d%n", "total", total);
    System.out.printf("%-10s %,d%n", "'cei'", cei);
    System.out.printf("%-10s %,d%n", "'cie'", cie);
    System.out.printf("%,d > (%,d * 2) = %b%n", cei, cie, cei > (cie * 2));
    System.out.printf("%,d > (%,d * 2) = %b", cie, cei, cie > (cei * 2));
}

static int total = 0;
static int cei = 0;
static int cie = 0;

static void count() throws URISyntaxException, IOException {
    URL url = new URI("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt").toURL();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()))) {
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.matches(".*?(?:[^c]ie|cei).*")) {
                cei++;
            } else if (line.matches(".*?(?:[^c]ei|cie).*")) {
                cie++;
            }
            total++;
        }
    }
}
