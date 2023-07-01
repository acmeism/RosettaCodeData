public static void main(String[] args) {
    long millis = System.currentTimeMillis();
    System.out.printf("%tF%n", millis);
    System.out.printf("%tA, %1$tB %1$td, %1$tY%n", millis);
}
