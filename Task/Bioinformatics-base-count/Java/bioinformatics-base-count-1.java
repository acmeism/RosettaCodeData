void printBaseCount(String string) throws IOException {
    BufferedReader reader = new BufferedReader(new StringReader(string));
    int index = 0;
    String sequence;
    int A = 0, C = 0, G = 0, T = 0;
    int a, c, g, t;
    while ((sequence = reader.readLine()) != null) {
        System.out.printf("%d %s ", index++, sequence);
        a = c = g = t = 0;
        for (char base : sequence.toCharArray()) {
            switch (base) {
                case 'A' -> {
                    A++;
                    a++;
                }
                case 'C' -> {
                    C++;
                    c++;
                }
                case 'G' -> {
                    G++;
                    g++;
                }
                case 'T' -> {
                    T++;
                    t++;
                }
            }
        }
        System.out.printf("[A %2d, C %2d, G %2d, T %2d]%n", a, c, g, t);
    }
    reader.close();
    int total = A + C + G + T;
    System.out.printf("%nTotal of %d bases%n", total);
    System.out.printf("A %3d (%.2f%%)%n", A, ((double) A / total) * 100);
    System.out.printf("C %3d (%.2f%%)%n", C, ((double) C / total) * 100);
    System.out.printf("G %3d (%.2f%%)%n", G, ((double) G / total) * 100);
    System.out.printf("T %3d (%.2f%%)%n", T, ((double) T / total) * 100);
}
