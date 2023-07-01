public static void main(String[] args) {
    File fileA = new File("file.txt");
    System.out.printf("%,d B%n", fileA.length());
    File fileB = new File("/file.txt");
    System.out.printf("%,d B%n", fileB.length());
}
